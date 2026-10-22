/* micro-gemm: concurrent independent create/join calls.
 *
 * Distilled from applications/gemm: cblas_i8gemm is safe to call from
 * several application threads at once; each call partitions and joins
 * its own worker group over a disjoint output region.  Two parent
 * threads each run their own partitioned call concurrently.
 *
 * Expected: DRF.
 */

#include <stdint.h>
#include <stdio.h>
#include <pthread.h>

enum { rows = 64, columns = 64, depth = 48, parent_count = 2,
       workers_per_parent = 2 };

static int8_t input_a[rows * depth];
static int8_t input_b[depth * columns];
static int32_t output[rows * columns];
static int32_t ref_output[rows * columns];

struct column_range {
    int64_t from;
    int64_t to;
};

struct call_group {
    struct column_range ranges[workers_per_parent];
    pthread_t threads[workers_per_parent];
};

static struct call_group groups[parent_count];

static void fill_inputs(void) {
    for (int64_t r = 0; r < rows; r++)
        for (int64_t k = 0; k < depth; k++)
            input_a[r * depth + k] = (int8_t)(((r * 7 + k * 3) % 11) - 5);
    for (int64_t k = 0; k < depth; k++)
        for (int64_t c = 0; c < columns; c++)
            input_b[k * columns + c] = (int8_t)(((k * 5 + c * 3) % 13) - 6);
}

static void compute_columns(int64_t from, int64_t to) {
    for (int64_t col = from; col < to; col++)
        for (int64_t row = 0; row < rows; row++) {
            int32_t sum = 0;
            for (int64_t k = 0; k < depth; k++)
                sum += input_a[row * depth + k] * input_b[k * columns + col];
            output[row * columns + col] = sum;
        }
}

static void *range_worker(void *arg) {
    struct column_range *range = arg;
    compute_columns(range->from, range->to);
    return NULL;
}

static void *parent_thread(void *arg) {
    struct call_group *group = arg;
    int64_t remaining = group->ranges[workers_per_parent - 1].to -
                        group->ranges[0].from;
    int64_t next_from = group->ranges[0].from;

    for (int64_t i = 0; i < workers_per_parent; i++) {
        int64_t width = (remaining + workers_per_parent - i - 1) /
                        (workers_per_parent - i);

        group->ranges[i].from = next_from;
        group->ranges[i].to = next_from + width;
        next_from += width;
        remaining -= width;
    }

    for (int64_t i = 0; i < workers_per_parent; i++)
        if (pthread_create(&group->threads[i], NULL, range_worker,
                           &group->ranges[i]) != 0) return NULL;
    for (int64_t i = 0; i < workers_per_parent; i++)
        pthread_join(group->threads[i], NULL);
    return NULL;
}

int main(void) {
    pthread_t parents[parent_count];
    const int64_t parent_width = columns / parent_count;

    fill_inputs();

    for (int64_t p = 0; p < parent_count; p++) {
        int64_t from = p * parent_width;
        int64_t to = (p == parent_count - 1) ? columns : (p + 1) * parent_width;

        groups[p].ranges[0].from = from;
        groups[p].ranges[workers_per_parent - 1].to = to;
    }

    for (int64_t p = 0; p < parent_count; p++)
        if (pthread_create(&parents[p], NULL, parent_thread, &groups[p]) != 0) return 1;
    for (int64_t p = 0; p < parent_count; p++)
        if (pthread_join(parents[p], NULL) != 0) return 1;

    for (int64_t col = 0; col < columns; col++)
        for (int64_t row = 0; row < rows; row++) {
            int32_t sum = 0;
            for (int64_t k = 0; k < depth; k++)
                sum += input_a[row * depth + k] * input_b[k * columns + col];
            ref_output[row * columns + col] = sum;
        }

    for (int64_t i = 0; i < rows * columns; i++)
        if (output[i] != ref_output[i]) {
            printf("FAIL concurrent_calls\n");
            return 1;
        }
    printf("PASS concurrent_calls\n");
    return 0;
}
