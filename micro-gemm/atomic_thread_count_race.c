/* micro-gemm RACE: worker republishes the count mid-flight.
 *
 * Mutation of atomic_thread_count.c: worker 0 stores a new worker count
 * while the other workers load it to derive their slices, and the count
 * is a plain int, so the store races with the loads.
 *
 * Dual: atomic_thread_count.c.  Expected: UNRESOLVED (real race).
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

int worker_count = 0;

void *count_worker(void *arg) {
    int64_t index = (int64_t)(intptr_t)arg;
    int count = worker_count;                                      // RACE! plain concurrent load

    if (index == 0)
        worker_count = 3;                                          // RACE! store while others load

    {
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
    }
    return NULL;
}

int main(void) {
    pthread_t threads[thread_count];

    for (int64_t m = 0; m < rows_m; m++)
        for (int64_t k = 0; k < depth_k; k++)
            input_a[m * depth_k + k] = (int8_t)(((m * 7 + k * 3) % 11) - 5);
    for (int64_t n = 0; n < cols_n; n++)
        for (int64_t k = 0; k < depth_k; k++)
            input_b[n * depth_k + k] = (int8_t)(((n * 5 + k * 3) % 13) - 6);
    memset(output_c, 1, sizeof output_c);
    worker_count = thread_count;

    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_create(&threads[i], NULL, count_worker, (void *)(intptr_t)i) != 0) return 1;
    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_join(threads[i], NULL) != 0) return 1;

    printf("DONE atomic_thread_count_race\n");
    return 0;
}
