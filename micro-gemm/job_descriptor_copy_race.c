/* micro-gemm RACE: descriptor mutated after pthread_create.
 *
 * Mutation of job_descriptor_copy.c: the caller widens worker 0's
 * column_to after creating it, racing with the worker's reads of the
 * descriptor it was promised to be immutable.
 *
 * Dual: job_descriptor_copy.c.  Expected: UNRESOLVED (real race).
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

struct job_plan {
    int32_t *output;
    int64_t column_from;
    int64_t column_to;
    int32_t alpha;
    int32_t beta;
};

struct job_plan plans[thread_count];

void *plan_worker(void *arg) {
    struct job_plan *plan = arg;

    for (int64_t n = plan->column_from; n < plan->column_to; n++) {  // RACE! parent mutates
        for (int64_t m = 0; m < rows_m; m++)
            plan->output[m * cols_n + n] *= plan->beta;
        for (int64_t m = 0; m < rows_m; m++) {
            int32_t sum = 0;

            for (int64_t k = 0; k < depth_k; k++)
                sum += input_a[m * depth_k + k] * input_b[n * depth_k + k];
            plan->output[m * cols_n + n] += plan->alpha * sum;
        }
    }
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
        plans[i].output = output_c;
        plans[i].column_from = i * width;
        plans[i].column_to = (i == thread_count - 1) ? cols_n : (i + 1) * width;
        plans[i].alpha = alpha_scale;
        plans[i].beta = beta_scale;
    }

    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_create(&threads[i], NULL, plan_worker, &plans[i]) != 0) return 1;

    plans[0].column_to = cols_n;                                  // RACE! write after create

    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_join(threads[i], NULL) != 0) return 1;

    printf("DONE job_descriptor_copy_race\n");
    return 0;
}
