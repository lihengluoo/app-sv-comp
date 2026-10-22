/* micro-gemm RACE: descriptor mutated after pthread_create.
 *
 * Mutation of job_descriptor_copy.c: the caller widens worker 0's
 * column_to after creating it, racing with the worker's reads of the
 * descriptor it was promised to be immutable.
 *
 * Expected: UNRESOLVED (real race).
 */

#include <stdint.h>
#include <stdio.h>
#include <pthread.h>

enum { rows = 64, columns = 64, depth = 48, thread_count = 4 };

static int8_t input_a[rows * depth];
static int8_t input_b[depth * columns];
static int32_t output[rows * columns];

struct job_plan {
    int32_t *output;
    int64_t column_from;
    int64_t column_to;
};

static struct job_plan plans[thread_count];

static void *plan_worker(void *arg) {
    struct job_plan *plan = arg;

    for (int64_t col = plan->column_from; col < plan->column_to; col++)  // RACE! parent mutates
        for (int64_t row = 0; row < rows; row++) {
            int32_t sum = 0;
            for (int64_t k = 0; k < depth; k++)
                sum += input_a[row * depth + k] * input_b[k * columns + col];
            plan->output[row * columns + col] = sum;
        }
    return NULL;
}

int main(void) {
    pthread_t threads[thread_count];
    const int64_t width = columns / thread_count;

    for (int64_t r = 0; r < rows; r++)
        for (int64_t k = 0; k < depth; k++)
            input_a[r * depth + k] = (int8_t)(((r * 7 + k * 3) % 11) - 5);
    for (int64_t k = 0; k < depth; k++)
        for (int64_t c = 0; c < columns; c++)
            input_b[k * columns + c] = (int8_t)(((k * 5 + c * 3) % 13) - 6);

    for (int64_t i = 0; i < thread_count; i++) {
        plans[i].output = output;
        plans[i].column_from = i * width;
        plans[i].column_to = (i == thread_count - 1) ? columns : (i + 1) * width;
    }

    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_create(&threads[i], NULL, plan_worker, &plans[i]) != 0) return 1;

    plans[0].column_to = columns;                                // RACE! write after create

    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_join(threads[i], NULL) != 0) return 1;

    printf("DONE job_descriptor_copy_race\n");
    return 0;
}
