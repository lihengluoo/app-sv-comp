/* micro-gemm: sequential partitioned calls over the same output.
 *
 * Distilled from applications/gemm: the check harness calls cblas_i8gemm
 * repeatedly; every call re-partitions the whole C matrix across fresh
 * workers.  The join at the end of one call orders the writes of the
 * next call, so accumulation across calls stays race-free.
 *
 * Expected: DRF.
 */

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

enum { rows = 64, columns = 64, depth = 48, thread_count = 4, call_count = 3 };

static int8_t input_a[rows * depth];
static int8_t input_b[depth * columns];
static int32_t output[rows * columns];
static int32_t ref_output[rows * columns];

struct column_range {
    int64_t from;
    int64_t to;
    int32_t scale;
};

static struct column_range ranges[thread_count];

static void fill_inputs(void) {
    for (int64_t r = 0; r < rows; r++)
        for (int64_t k = 0; k < depth; k++)
            input_a[r * depth + k] = (int8_t)(((r * 7 + k * 3) % 11) - 5);
    for (int64_t k = 0; k < depth; k++)
        for (int64_t c = 0; c < columns; c++)
            input_b[k * columns + c] = (int8_t)(((k * 5 + c * 3) % 13) - 6);
}

static void compute_columns(int64_t from, int64_t to, int32_t scale) {
    for (int64_t col = from; col < to; col++)
        for (int64_t row = 0; row < rows; row++) {
            int32_t sum = 0;
            for (int64_t k = 0; k < depth; k++)
                sum += input_a[row * depth + k] * input_b[k * columns + col];
            output[row * columns + col] += scale * sum;
        }
}

static void *range_worker(void *arg) {
    struct column_range *range = arg;
    compute_columns(range->from, range->to, (int32_t)range->scale);
    return NULL;
}

static void run_partitioned_call(int32_t scale) {
    pthread_t threads[thread_count];
    int64_t remaining = columns;
    int64_t next_from = 0;

    for (int64_t i = 0; i < thread_count; i++) {
        int64_t width = (remaining + thread_count - i - 1) / (thread_count - i);

        ranges[i].from = next_from;
        ranges[i].to = next_from + width;
        ranges[i].scale = scale;
        next_from += width;
        remaining -= width;
    }

    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_create(&threads[i], NULL, range_worker, &ranges[i]) != 0) exit(1);
    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_join(threads[i], NULL) != 0) exit(1);
}

int main(void) {
    fill_inputs();

    for (int32_t call = 1; call <= call_count; call++)
        run_partitioned_call(call);

    for (int64_t col = 0; col < columns; col++)
        for (int64_t row = 0; row < rows; row++) {
            int32_t sum = 0;
            for (int64_t k = 0; k < depth; k++)
                sum += input_a[row * depth + k] * input_b[k * columns + col];
            ref_output[row * columns + col] = sum * (1 + 2 + 3);
        }

    for (int64_t i = 0; i < rows * columns; i++)
        if (output[i] != ref_output[i]) {
            printf("FAIL sequential_calls\n");
            return 1;
        }
    printf("PASS sequential_calls\n");
    return 0;
}
