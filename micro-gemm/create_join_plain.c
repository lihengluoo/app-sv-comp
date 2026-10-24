/* micro-gemm: plain create/join, no shared memory.
 *
 * Distilled from applications/gemm: blas_server.c exec_blas spawns workers
 * and joins them; the baseline obligation is that a lone worker doing the
 * whole GEMM into thread-private memory needs no synchronization beyond
 * pthread_create/pthread_join.
 *
 * The worker computes C = alpha * A * B + beta * C for the full matrix
 * into a stack-local buffer (the real gemm arithmetic, zero sharing) and
 * publishes only the checksum through its join return.
 *
 * Dual: create_join_plain_race.c.  Expected: DRF.
 */

#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <pthread.h>

#define rows_m 64
#define cols_n 64
#define depth_k 64
#define alpha_scale 2
#define beta_scale 5

int8_t input_a[rows_m * depth_k];
int8_t input_b[cols_n * depth_k];

void fill_inputs(void) {
    for (int64_t m = 0; m < rows_m; m++)
        for (int64_t k = 0; k < depth_k; k++)
            input_a[m * depth_k + k] = (int8_t)(((m * 7 + k * 3) % 11) - 5);
    for (int64_t n = 0; n < cols_n; n++)
        for (int64_t k = 0; k < depth_k; k++)
            input_b[n * depth_k + k] = (int8_t)(((n * 5 + k * 3) % 13) - 6);
}

/* The real gemm column: beta pre-scale (write), then alpha-accumulate
   (read-modify-write), on a caller-owned destination. */
void gemm_column(int32_t *dst, int64_t n, int32_t alpha, int32_t beta) {
    for (int64_t m = 0; m < rows_m; m++)
        dst[m * cols_n + n] *= beta;
    for (int64_t m = 0; m < rows_m; m++) {
        int32_t sum = 0;

        for (int64_t k = 0; k < depth_k; k++)
            sum += input_a[m * depth_k + k] * input_b[n * depth_k + k];
        dst[m * cols_n + n] += alpha * sum;
    }
}

void *gemm_worker(void *unused) {
    int32_t local_c[rows_m * cols_n];
    int64_t checksum = 0;

    (void)unused;
    memset(local_c, 1, sizeof local_c);
    for (int64_t n = 0; n < cols_n; n++)
        gemm_column(local_c, n, alpha_scale, beta_scale);
    for (int64_t i = 0; i < rows_m * cols_n; i++)
        checksum += local_c[i];
    return (void *)(intptr_t)checksum;
}

int main(void) {
    pthread_t thread;
    void *result = NULL;
    int32_t ref_c[rows_m * cols_n];
    int64_t ref_checksum = 0;

    fill_inputs();
    memset(ref_c, 1, sizeof ref_c);
    for (int64_t n = 0; n < cols_n; n++)
        gemm_column(ref_c, n, alpha_scale, beta_scale);
    for (int64_t i = 0; i < rows_m * cols_n; i++)
        ref_checksum += ref_c[i];

    if (pthread_create(&thread, NULL, gemm_worker, NULL) != 0) return 1;
    if (pthread_join(thread, &result) != 0) return 1;

    if ((intptr_t)result != ref_checksum) {
        printf("FAIL create_join_plain\n");
        return 1;
    }
    printf("PASS create_join_plain\n");
    return 0;
}
