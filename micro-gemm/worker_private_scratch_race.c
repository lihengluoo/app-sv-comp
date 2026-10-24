/* micro-gemm RACE: workers share one packing scratch buffer.
 *
 * Mutation of worker_private_scratch.c: the caller allocates a single
 * scratch buffer and hands the same pointer to every worker descriptor,
 * so all workers pack the B column into the same memory and compute from
 * it concurrently.
 *
 * Dual: worker_private_scratch.c.  Expected: UNRESOLVED (real race).
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
#define alpha_scale 2
#define beta_scale 5

int8_t input_a[rows_m * depth_k];
int8_t input_b[cols_n * depth_k];
int32_t output_c[rows_m * cols_n];

struct job_plan {
    int8_t *shared_packed;
    int64_t column_from;
    int64_t column_to;
};

struct job_plan plans[thread_count];

void *plan_worker(void *arg) {
    struct job_plan *plan = arg;

    for (int64_t n = plan->column_from; n < plan->column_to; n++) {
        memcpy(plan->shared_packed, &input_b[n * depth_k], (size_t)depth_k);  // RACE! one buffer

        for (int64_t m = 0; m < rows_m; m++)
            output_c[m * cols_n + n] *= beta_scale;
        for (int64_t m = 0; m < rows_m; m++) {
            int32_t sum = 0;

            for (int64_t k = 0; k < depth_k; k++)
                sum += input_a[m * depth_k + k] * plan->shared_packed[k];     // RACE! one buffer
            output_c[m * cols_n + n] += alpha_scale * sum;
        }
    }
    return NULL;
}

int main(void) {
    pthread_t threads[thread_count];
    int8_t *shared_packed = aligned_alloc(64, (size_t)depth_k);
    const int64_t width = cols_n / thread_count;

    if (shared_packed == NULL) return 1;

    for (int64_t m = 0; m < rows_m; m++)
        for (int64_t k = 0; k < depth_k; k++)
            input_a[m * depth_k + k] = (int8_t)(((m * 7 + k * 3) % 11) - 5);
    for (int64_t n = 0; n < cols_n; n++)
        for (int64_t k = 0; k < depth_k; k++)
            input_b[n * depth_k + k] = (int8_t)(((n * 5 + k * 3) % 13) - 6);
    memset(output_c, 1, sizeof output_c);

    for (int64_t i = 0; i < thread_count; i++) {
        plans[i].shared_packed = shared_packed;
        plans[i].column_from = i * width;
        plans[i].column_to = (i == thread_count - 1) ? cols_n : (i + 1) * width;
    }

    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_create(&threads[i], NULL, plan_worker, &plans[i]) != 0) return 1;
    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_join(threads[i], NULL) != 0) return 1;

    free(shared_packed);
    printf("DONE worker_private_scratch_race\n");
    return 0;
}
