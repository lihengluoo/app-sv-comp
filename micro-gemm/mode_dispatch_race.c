/* micro-gemm RACE: one dispatch case computes a neighbor's column.
 *
 * Mutation of mode_dispatch.c: the beta-zero overwrite case walks one
 * column past the slice end, racing with the worker that owns that
 * column.
 *
 * Dual: mode_dispatch.c.  Expected: UNRESOLVED (real race).
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
#define mode_plain 0
#define mode_overwrite 1
#define mode_ksplit 2
#define mode_msplit 3

int8_t input_a[rows_m * depth_k];
int8_t input_b[cols_n * depth_k];
int32_t output_c[rows_m * cols_n];

struct job_plan {
    int64_t column_from;
    int64_t column_to;
    int32_t mode;
};

struct job_plan plans[thread_count];

int32_t dot_full(int64_t m, int64_t n) {
    int32_t sum = 0;

    for (int64_t k = 0; k < depth_k; k++)
        sum += input_a[m * depth_k + k] * input_b[n * depth_k + k];
    return sum;
}

int32_t dot_k_split(int64_t m, int64_t n) {
    int32_t low = 0;
    int32_t high = 0;

    for (int64_t k = 0; k < depth_k / 2; k++)
        low += input_a[m * depth_k + k] * input_b[n * depth_k + k];
    for (int64_t k = depth_k / 2; k < depth_k; k++)
        high += input_a[m * depth_k + k] * input_b[n * depth_k + k];
    return low + high;
}

void gemm_column_mode(int64_t n, int32_t mode) {
    switch (mode) {
    case mode_plain:
        for (int64_t m = 0; m < rows_m; m++)
            output_c[m * cols_n + n] = output_c[m * cols_n + n] * beta_scale +
                                       alpha_scale * dot_full(m, n);
        break;
    case mode_overwrite:
        for (int64_t m = 0; m < rows_m; m++)
            output_c[m * cols_n + n] = alpha_scale * dot_full(m, n);
        break;
    case mode_ksplit:
        for (int64_t m = 0; m < rows_m; m++)
            output_c[m * cols_n + n] = output_c[m * cols_n + n] * beta_scale +
                                       alpha_scale * dot_k_split(m, n);
        break;
    default:
        for (int64_t m = 0; m < rows_m; m++)
            output_c[m * cols_n + n] = output_c[m * cols_n + n] * beta_scale +
                                       alpha_scale * dot_full(m, n);
        break;
    }
}

void *plan_worker(void *arg) {
    struct job_plan *plan = arg;
    int64_t to = plan->column_to;

    if (plan->mode == mode_overwrite) to = plan->column_to + 1;    // RACE! case oversteps

    for (int64_t n = plan->column_from; n < to; n++)
        gemm_column_mode(n, plan->mode);
    return NULL;
}

int main(void) {
    pthread_t threads[thread_count];
    const int64_t width = cols_n / thread_count;

    for (int64_t m = 0; m < rows_m; m++)
        for (int64_t k = 0; k < depth_k; k++)
            input_a[m * depth_k + k] = (int8_t)(((m * 7 + k * 3) % 11) - 5);
    for (int64_t n = 0; n < cols_n; n++)
        for (int64_t k = 0; k < depth_k; k++)
            input_b[n * depth_k + k] = (int8_t)(((n * 5 + k * 3) % 13) - 6);
    memset(output_c, 1, sizeof output_c);

    for (int64_t i = 0; i < thread_count; i++) {
        plans[i].column_from = i * width;
        plans[i].column_to = (i == thread_count - 1) ? cols_n : (i + 1) * width;
        plans[i].mode = (int32_t)(i & 3);
    }

    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_create(&threads[i], NULL, plan_worker, &plans[i]) != 0) return 1;
    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_join(threads[i], NULL) != 0) return 1;

    printf("DONE mode_dispatch_race\n");
    return 0;
}
