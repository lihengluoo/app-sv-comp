/* micro-gemm: atomically published worker count drives the partition.
 *
 * Distilled from applications/gemm: blas_cpu_number is a _Atomic int the
 * interface reads (num_cpu_avail) to decide how many column slices to
 * build before creating the workers.  The count is stored before any
 * create and only loaded by the workers, whose gemm slices are derived
 * from it.
 *
 * Dual: atomic_thread_count_race.c.  Expected: DRF.
 */

#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <pthread.h>
#include <stdatomic.h>

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

_Atomic int worker_count = 0;

void fill_inputs(void) {
    for (int64_t m = 0; m < rows_m; m++)
        for (int64_t k = 0; k < depth_k; k++)
            input_a[m * depth_k + k] = (int8_t)(((m * 7 + k * 3) % 11) - 5);
    for (int64_t n = 0; n < cols_n; n++)
        for (int64_t k = 0; k < depth_k; k++)
            input_b[n * depth_k + k] = (int8_t)(((n * 5 + k * 3) % 13) - 6);
}

void *count_worker(void *arg) {
    int64_t index = (int64_t)(intptr_t)arg;
    int count = atomic_load(&worker_count);
    int64_t width = cols_n / count;
    int64_t from = index * width;
    int64_t to = (index == count - 1) ? cols_n : from + width;

    for (int64_t n = from; n < to; n++) {
        for (int64_t m = 0; m < rows_m; m++)
            output_c[m * cols_n + n] *= beta_scale;
        for (int64_t m = 0; m < rows_m; m++) {
            int32_t sum = 0;

            for (int64_t k = 0; k < depth_k; k++)
                sum += input_a[m * depth_k + k] * input_b[n * depth_k + k];
            output_c[m * cols_n + n] += alpha_scale * sum;
        }
    }
    return NULL;
}

int main(void) {
    pthread_t threads[thread_count];

    fill_inputs();
    memset(output_c, 1, sizeof output_c);
    atomic_store(&worker_count, thread_count);

    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_create(&threads[i], NULL, count_worker, (void *)(intptr_t)i) != 0) return 1;
    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_join(threads[i], NULL) != 0) return 1;

    memset(ref_c, 1, sizeof ref_c);
    for (int64_t n = 0; n < cols_n; n++)
        for (int64_t m = 0; m < rows_m; m++) {
            int32_t sum = 0;

            for (int64_t k = 0; k < depth_k; k++)
                sum += input_a[m * depth_k + k] * input_b[n * depth_k + k];
            ref_c[m * cols_n + n] = ref_c[m * cols_n + n] * beta_scale + alpha_scale * sum;
        }

    for (int64_t i = 0; i < rows_m * cols_n; i++)
        if (output_c[i] != ref_c[i]) {
            printf("FAIL atomic_thread_count\n");
            return 1;
        }
    printf("PASS atomic_thread_count\n");
    return 0;
}
