/* micro-gemm RACE: caller and worker both write the result slot.
 *
 * Mutation of create_join_plain.c: instead of publishing only through
 * the join return, the worker also stores its checksum into a shared
 * slot, and the main thread clears the same slot while the worker may
 * still be running.
 *
 * Dual: create_join_plain.c.  Expected: UNRESOLVED (real race).
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
int64_t result_slot = 0;

void fill_inputs(void) {
    for (int64_t m = 0; m < rows_m; m++)
        for (int64_t k = 0; k < depth_k; k++)
            input_a[m * depth_k + k] = (int8_t)(((m * 7 + k * 3) % 11) - 5);
    for (int64_t n = 0; n < cols_n; n++)
        for (int64_t k = 0; k < depth_k; k++)
            input_b[n * depth_k + k] = (int8_t)(((n * 5 + k * 3) % 13) - 6);
}

void *gemm_worker(void *unused) {
    int32_t local_c[rows_m * cols_n];
    int64_t checksum = 0;

    (void)unused;
    memset(local_c, 1, sizeof local_c);
    for (int64_t n = 0; n < cols_n; n++) {
        for (int64_t m = 0; m < rows_m; m++)
            local_c[m * cols_n + n] *= beta_scale;
        for (int64_t m = 0; m < rows_m; m++) {
            int32_t sum = 0;

            for (int64_t k = 0; k < depth_k; k++)
                sum += input_a[m * depth_k + k] * input_b[n * depth_k + k];
            local_c[m * cols_n + n] += alpha_scale * sum;
        }
    }
    for (int64_t i = 0; i < rows_m * cols_n; i++)
        checksum += local_c[i];

    result_slot = checksum;                                       // RACE! main clears it too
    return (void *)(intptr_t)checksum;
}

int main(void) {
    pthread_t thread;

    fill_inputs();
    if (pthread_create(&thread, NULL, gemm_worker, NULL) != 0) return 1;

    result_slot = 0;                                              // RACE! concurrent with worker

    if (pthread_join(thread, NULL) != 0) return 1;

    printf("DONE create_join_plain_race slot=%lld\n", (long long)result_slot);
    return 0;
}
