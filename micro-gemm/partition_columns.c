/* micro-gemm: balanced disjoint column partition across workers.
 *
 * Distilled from applications/gemm: gemm_thread_n.c divides the N
 * dimension with the blas_quickdivide balance loop, each worker computes
 * real gemm slices (beta pre-scale, then alpha-accumulate) strictly inside
 * its own column range, and pthread_join publishes the slices to the
 * caller.  This is the core memory-partitioning pattern.
 *
 * Dual: partition_columns_race.c.  Expected: DRF.
 */

#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <pthread.h>

#define rows_m 64
#define cols_n 64
#define depth_k 64
#define thread_count 4
#define alpha_scale 2
#define beta_scale 5

int8_t input_a[rows_m * depth_k];
int8_t input_b[cols_n * depth_k];
int32_t output_c[rows_m * cols_n];
int32_t ref_c[rows_m * cols_n];

struct column_range {
    int64_t from;
    int64_t to;
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

void gemm_column(int64_t n) {
    for (int64_t m = 0; m < rows_m; m++)
        output_c[m * cols_n + n] *= beta_scale;
    for (int64_t m = 0; m < rows_m; m++) {
        int32_t sum = 0;

        for (int64_t k = 0; k < depth_k; k++)
            sum += input_a[m * depth_k + k] * input_b[n * depth_k + k];
        output_c[m * cols_n + n] += alpha_scale * sum;
    }
}

void *range_worker(void *arg) {
    struct column_range *range = arg;

    for (int64_t n = range->from; n < range->to; n++)
        gemm_column(n);
    return NULL;
}

int main(void) {
    pthread_t threads[thread_count];
    int64_t remaining = cols_n;
    int64_t next_from = 0;

    fill_inputs();
    memset(output_c, 1, sizeof output_c);

    /* The same balance loop as gemm_thread_n: each worker takes an equal
       share of whatever columns are left, so the slices tile [0, cols_n)
       with no gap and no overlap. */
    for (int64_t i = 0; i < thread_count; i++) {
        int64_t width = (remaining + thread_count - i - 1) / (thread_count - i);

        ranges[i].from = next_from;
        ranges[i].to = next_from + width;
        next_from += width;
        remaining -= width;
    }

    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_create(&threads[i], NULL, range_worker, &ranges[i]) != 0) return 1;
    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_join(threads[i], NULL) != 0) return 1;

    memset(ref_c, 1, sizeof ref_c);
    for (int64_t n = 0; n < cols_n; n++) {
        for (int64_t m = 0; m < rows_m; m++)
            ref_c[m * cols_n + n] *= beta_scale;
        for (int64_t m = 0; m < rows_m; m++) {
            int32_t sum = 0;

            for (int64_t k = 0; k < depth_k; k++)
                sum += input_a[m * depth_k + k] * input_b[n * depth_k + k];
            ref_c[m * cols_n + n] += alpha_scale * sum;
        }
    }

    for (int64_t i = 0; i < rows_m * cols_n; i++)
        if (output_c[i] != ref_c[i]) {
            printf("FAIL partition_columns\n");
            return 1;
        }
    printf("PASS partition_columns\n");
    return 0;
}
