/* micro-gemm: plain create/join, no shared memory.
 *
 * Distilled from applications/gemm: blas_server.c exec_blas spawns workers
 * and joins them; the baseline obligation is that a lone worker returning
 * its result through pthread_join needs no other synchronization.
 *
 * Expected: DRF.
 */

#include <stdint.h>
#include <stdio.h>
#include <pthread.h>

enum { sum_upper = 64, expected_sum = 64 * 65 / 2 };

static void *sum_worker(void *unused) {
    int32_t sum = 0;
    (void)unused;
    for (int32_t i = 1; i <= sum_upper; i++) sum += i;
    return (void *)(intptr_t)sum;
}

int main(void) {
    pthread_t thread;
    void *result = NULL;

    if (pthread_create(&thread, NULL, sum_worker, NULL) != 0) return 1;
    if (pthread_join(thread, &result) != 0) return 1;

    if ((intptr_t)result != expected_sum) {
        printf("FAIL create_join_plain\n");
        return 1;
    }
    printf("PASS create_join_plain\n");
    return 0;
}
