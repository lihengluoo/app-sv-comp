/* micro-gemm: each worker writes one disjoint index of the output array.
 *
 * Distilled from the thread-count partition in applications/gemm: every
 * worker owns its output slice, so the stores never share an index.
 *
 * Dual: partition-race.c.  Expected: DRF.
 */

#include <stdint.h>
#include <pthread.h>

int output_c[4];

void *slot_worker(void *arg) {
    int index = (int)(intptr_t)arg;

    output_c[index] = 4; // NORACE
    return NULL;
}

int main(void) {
    pthread_t threads[4];

    for (int i = 0; i < 4; i++)
        pthread_create(&threads[i], NULL, slot_worker, (void *)(intptr_t)i); // may fail
    for (int i = 0; i < 4; i++)
        pthread_join(threads[i], NULL); // may fail
    return 0;
}
