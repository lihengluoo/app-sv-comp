/* micro-gemm: immutable job descriptors copied by each worker.
 *
 * Distilled from applications/gemm: gemm_thread_n.c builds blas_queue_t
 * nodes (args pointer, range_n bounds, mode, position) before exec_blas
 * creates the workers; each worker reads its node as an immutable input.
 * The worker takes a private struct copy of the descriptor, the shape
 * verifier_gemm_inputs.ll distills as { ptr, ptr, i64, i64 } plus memcpy.
 *
 * Expected: DRF.
 */

#include <stdint.h>
#include <stdio.h>
#include <pthread.h>

enum { rows = 64, columns = 64, depth = 48, thread_count = 4 };

static int8_t input_a[rows * depth];
static int8_t input_b[depth * columns];
static int32_t output[rows * columns];
static int32_t ref_output[rows * columns];

struct job_plan {
    int32_t *output;
    int64_t column_from;
    int64_t column_to;
};

static struct job_plan plans[thread_count];

static void fill_inputs(void) {
    for (int64_t r = 0; r < rows; r++)
        for (int64_t k = 0; k < depth; k++)
            input_a[r * depth + k] = (int8_t)(((r * 7 + k * 3) % 11) - 5);
    for (int64_t k = 0; k < depth; k++)
        for (int64_t c = 0; c < columns; c++)
            input_b[k * columns + c] = (int8_t)(((k * 5 + c * 3) % 13) - 6);
}

static void compute_slice(const struct job_plan *plan) {
    for (int64_t col = plan->column_from; col < plan->column_to; col++)
        for (int64_t row = 0; row < rows; row++) {
            int32_t sum = 0;
            for (int64_t k = 0; k < depth; k++)
                sum += input_a[row * depth + k] * input_b[k * columns + col];
            plan->output[row * columns + col] = sum;
        }
}

static void *plan_worker(void *arg) {
    struct job_plan plan = *(const struct job_plan *)arg;
    compute_slice(&plan);
    return NULL;
}

int main(void) {
    pthread_t threads[thread_count];
    const int64_t width = columns / thread_count;

    fill_inputs();

    for (int64_t i = 0; i < thread_count; i++) {
        plans[i].output = output;
        plans[i].column_from = i * width;
        plans[i].column_to = (i == thread_count - 1) ? columns : (i + 1) * width;
    }

    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_create(&threads[i], NULL, plan_worker, &plans[i]) != 0) return 1;
    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_join(threads[i], NULL) != 0) return 1;

    for (int64_t col = 0; col < columns; col++)
        for (int64_t row = 0; row < rows; row++) {
            int32_t sum = 0;
            for (int64_t k = 0; k < depth; k++)
                sum += input_a[row * depth + k] * input_b[k * columns + col];
            ref_output[row * columns + col] = sum;
        }

    for (int64_t i = 0; i < rows * columns; i++)
        if (output[i] != ref_output[i]) {
            printf("FAIL job_descriptor_copy\n");
            return 1;
        }
    printf("PASS job_descriptor_copy\n");
    return 0;
}
