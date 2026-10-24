/* micro-gemm: sequential partitioned calls over the same output.
 *
 * Distilled from applications/gemm: the check harness calls cblas_i8gemm
 * repeatedly; every call re-partitions the whole C matrix across fresh
 * workers.  The join at the end of one call orders the writes of the
 * next call.  Call 1 uses beta = 0 (pure overwrite, the first-writer
 * kernel path); call 2 accumulates with beta = 1.
 *
 * Dual: sequential_calls_race.c.  Expected: DRF.
 */

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>

#define rows_m 64
#define cols_n 64
#define depth_k 64
#define thread_count 4
#define call_count 2

int8_t input_a[rows_m * depth_k];
int8_t input_b[cols_n * depth_k];
int32_t output_c[rows_m * cols_n];
int32_t ref_c[rows_m * cols_n];

struct column_range {
    int64_t from;
    int64_t to;
    int32_t alpha;
    int32_t beta;
};

struct column_range ranges[thread_count];

void fill_inputs(void) {
    for (int64_t m = 0; m < rows_m; m++)
        for (int64_t k = 0; k < depth_k; k++)
            input_a[m * depth_k + k] = (int8_t)(((m * 7 + k * 3) % 11) - 5);
    for (int64_t n = 0; n < cols_n; n++)
        for (int64_t k = 0; k < depth_k; k++)
            input_b[n * depth_k + k] = (int8_t)(((n * 5 + k * 3) % 13) - 6);
}

void gemm_column(int64_t n, int32_t alpha, int32_t beta) {
    for (int64_t m = 0; m < rows_m; m++) {
        int32_t sum = 0;

        for (int64_t k = 0; k < depth_k; k++)
            sum += input_a[m * depth_k + k] * input_b[n * depth_k + k];
        if (beta != 0)
            output_c[m * cols_n + n] = output_c[m * cols_n + n] * beta + alpha * sum;
        else
            output_c[m * cols_n + n] = alpha * sum;
    }
}

void *range_worker(void *arg) {
    struct column_range *range = arg;

    for (int64_t n = range->from; n < range->to; n++)
        gemm_column(n, range->alpha, range->beta);
    return NULL;
}

void run_partitioned_call(int32_t alpha, int32_t beta) {
    pthread_t threads[thread_count];
    int64_t remaining = cols_n;
    int64_t next_from = 0;

    for (int64_t i = 0; i < thread_count; i++) {
        int64_t width = (remaining + thread_count - i - 1) / (thread_count - i);

        ranges[i].from = next_from;
        ranges[i].to = next_from + width;
        ranges[i].alpha = alpha;
        ranges[i].beta = beta;
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
    memset(output_c, 1, sizeof output_c);

    /* Call 1 overwrites (beta = 0), call 2 accumulates (beta = 1). */
    run_partitioned_call(2, 0);
    run_partitioned_call(3, 1);

    memset(ref_c, 1, sizeof ref_c);
    for (int64_t n = 0; n < cols_n; n++)
        for (int64_t m = 0; m < rows_m; m++) {
            int32_t sum = 0;

            for (int64_t k = 0; k < depth_k; k++)
                sum += input_a[m * depth_k + k] * input_b[n * depth_k + k];
            ref_c[m * cols_n + n] = 2 * sum;
            ref_c[m * cols_n + n] = ref_c[m * cols_n + n] + 3 * sum;
        }

    for (int64_t i = 0; i < rows_m * cols_n; i++)
        if (output_c[i] != ref_c[i]) {
            printf("FAIL sequential_calls\n");
            return 1;
        }
    printf("PASS sequential_calls\n");
    return 0;
}
