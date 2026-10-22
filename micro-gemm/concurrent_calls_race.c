/* micro-gemm RACE: concurrent calls with overlapping output regions.
 *
 * Mutation of concurrent_calls.c: the second parent's column range starts
 * one column inside the first parent's range, so their worker groups
 * write the boundary column concurrently.
 *
 * Expected: UNRESOLVED (real race).
 */

#include <stdint.h>
#include <stdio.h>
#include <pthread.h>

enum { rows = 64, columns = 64, depth = 48, parent_count = 2,
       workers_per_parent = 2 };

static int8_t input_a[rows * depth];
static int8_t input_b[depth * columns];
static int32_t output[rows * columns];

struct column_range {
    int64_t from;
    int64_t to;
};

struct call_group {
    struct column_range ranges[workers_per_parent];
    pthread_t threads[workers_per_parent];
};

static struct call_group groups[parent_count];

static void *range_worker(void *arg) {
    struct column_range *range = arg;

    for (int64_t col = range->from; col < range->to; col++)
        for (int64_t row = 0; row < rows; row++) {
            int32_t sum = 0;
            for (int64_t k = 0; k < depth; k++)
                sum += input_a[row * depth + k] * input_b[k * columns + col];
            output[row * columns + col] = sum;                   // RACE! overlapping parents
        }
    return NULL;
}

static void *parent_thread(void *arg) {
    struct call_group *group = arg;
    int64_t span = group->ranges[workers_per_parent - 1].to - group->ranges[0].from;
    int64_t next_from = group->ranges[0].from;

    for (int64_t i = 0; i < workers_per_parent; i++) {
        int64_t width = (span + workers_per_parent - i - 1) / (workers_per_parent - i);

        group->ranges[i].from = next_from;
        group->ranges[i].to = next_from + width;
        next_from += width;
        span -= width;
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

    for (int64_t r = 0; r < rows; r++)
        for (int64_t k = 0; k < depth; k++)
            input_a[r * depth + k] = (int8_t)(((r * 7 + k * 3) % 11) - 5);
    for (int64_t k = 0; k < depth; k++)
        for (int64_t c = 0; c < columns; c++)
            input_b[k * columns + c] = (int8_t)(((k * 5 + c * 3) % 13) - 6);

    for (int64_t p = 0; p < parent_count; p++) {
        int64_t from = (p == 0) ? 0 : p * parent_width - 1;      // RACE! overlap by one column
        int64_t to = (p == parent_count - 1) ? columns : (p + 1) * parent_width;

        groups[p].ranges[0].from = from;
        groups[p].ranges[workers_per_parent - 1].to = to;
    }

    for (int64_t p = 0; p < parent_count; p++)
        if (pthread_create(&parents[p], NULL, parent_thread, &groups[p]) != 0) return 1;
    for (int64_t p = 0; p < parent_count; p++)
        if (pthread_join(parents[p], NULL) != 0) return 1;

    printf("DONE concurrent_calls_race\n");
    return 0;
}
