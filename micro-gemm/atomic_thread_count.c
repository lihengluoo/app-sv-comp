/* micro-gemm: atomically published worker count drives the partition.
 *
 * Distilled from applications/gemm: blas_cpu_number is a _Atomic int the
 * interface reads (num_cpu_avail) to decide how many column slices to
 * build before creating the workers.  The count is stored before any
 * create and only loaded by the workers.
 *
 * Expected: DRF.
 */

#include <stdint.h>
#include <stdio.h>
#include <pthread.h>
#include <stdatomic.h>

enum { rows = 64, columns = 64, depth = 48, thread_count = 4 };

static int8_t input_a[rows * depth];
static int8_t input_b[depth * columns];
static int32_t output[rows * columns];
static int32_t ref_output[rows * columns];

static _Atomic int worker_count = 0;

static void fill_inputs(void) {
    for (int64_t r = 0; r < rows; r++)
        for (int64_t k = 0; k < depth; k++)
            input_a[r * depth + k] = (int8_t)(((r * 7 + k * 3) % 11) - 5);
    for (int64_t k = 0; k < depth; k++)
        for (int64_t c = 0; c < columns; c++)
            input_b[k * columns + c] = (int8_t)(((k * 5 + c * 3) % 13) - 6);
}

static void *count_worker(void *arg) {
    int64_t index = (int64_t)(intptr_t)arg;
    int count = atomic_load(&worker_count);
    int64_t width = columns / count;
    int64_t from = index * width;
    int64_t to = (index == count - 1) ? columns : from + width;

    for (int64_t col = from; col < to; col++)
        for (int64_t row = 0; row < rows; row++) {
            int32_t sum = 0;
            for (int64_t k = 0; k < depth; k++)
                sum += input_a[row * depth + k] * input_b[k * columns + col];
            output[row * columns + col] = sum;
        }
    return NULL;
}

int main(void) {
    pthread_t threads[thread_count];

    fill_inputs();
    atomic_store(&worker_count, thread_count);

    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_create(&threads[i], NULL, count_worker, (void *)(intptr_t)i) != 0) return 1;
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
            printf("FAIL atomic_thread_count\n");
            return 1;
        }
    printf("PASS atomic_thread_count\n");
    return 0;
}
