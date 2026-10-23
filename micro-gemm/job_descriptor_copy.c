/* micro-gemm: immutable job descriptors copied by each worker.
 *
 * Distilled from applications/gemm: gemm_thread_n.c builds blas_queue_t
 * nodes (args pointer, range_n bounds, mode, position) before exec_blas
 * creates the workers; each worker reads its node as an immutable input
 * and takes a private struct copy, the shape verifier_gemm_inputs.ll
 * distills.  Workers compute real gemm slices: beta pre-scale then
 * alpha-accumulate, each strictly inside its own column range.
 *
 * Dual: job_descriptor_copy_race.c.  Expected: DRF.
 */

#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <pthread.h>

enum { rows_m = 64, cols_n = 64, depth_k = 64, thread_count = 4,
       alpha_scale = 2, beta_scale = 5 };

static int8_t input_a[rows_m * depth_k];
static int8_t input_b[cols_n * depth_k];
static int32_t output_c[rows_m * cols_n];
static int32_t ref_c[rows_m * cols_n];

struct job_plan {
    int32_t *output;
    int64_t column_from;
    int64_t column_to;
    int32_t alpha;
    int32_t beta;
};

static struct job_plan plans[thread_count];

static void fill_inputs(void) {
    for (int64_t m = 0; m < rows_m; m++)
        for (int64_t k = 0; k < depth_k; k++)
            input_a[m * depth_k + k] = (int8_t)(((m * 7 + k * 3) % 11) - 5);
    for (int64_t n = 0; n < cols_n; n++)
        for (int64_t k = 0; k < depth_k; k++)
            input_b[n * depth_k + k] = (int8_t)(((n * 5 + k * 3) % 13) - 6);
}

static void gemm_column(int32_t *dst, int64_t n, int32_t alpha, int32_t beta) {
    for (int64_t m = 0; m < rows_m; m++)
        dst[m * cols_n + n] *= beta;
    for (int64_t m = 0; m < rows_m; m++) {
        int32_t sum = 0;

        for (int64_t k = 0; k < depth_k; k++)
            sum += input_a[m * depth_k + k] * input_b[n * depth_k + k];
        dst[m * cols_n + n] += alpha * sum;
    }
}

static void *plan_worker(void *arg) {
    struct job_plan plan = *(const struct job_plan *)arg;

    for (int64_t n = plan.column_from; n < plan.column_to; n++)
        gemm_column(plan.output, n, plan.alpha, plan.beta);
    return NULL;
}

int main(void) {
    pthread_t threads[thread_count];
    const int64_t width = cols_n / thread_count;

    fill_inputs();
    memset(output_c, 1, sizeof output_c);

    for (int64_t i = 0; i < thread_count; i++) {
        plans[i].output = output_c;
        plans[i].column_from = i * width;
        plans[i].column_to = (i == thread_count - 1) ? cols_n : (i + 1) * width;
        plans[i].alpha = alpha_scale;
        plans[i].beta = beta_scale;
    }

    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_create(&threads[i], NULL, plan_worker, &plans[i]) != 0) return 1;
    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_join(threads[i], NULL) != 0) return 1;

    memset(ref_c, 1, sizeof ref_c);
    for (int64_t n = 0; n < cols_n; n++)
        gemm_column(ref_c, n, alpha_scale, beta_scale);

    for (int64_t i = 0; i < rows_m * cols_n; i++)
        if (output_c[i] != ref_c[i]) {
            printf("FAIL job_descriptor_copy\n");
            return 1;
        }
    printf("PASS job_descriptor_copy\n");
    return 0;
}
