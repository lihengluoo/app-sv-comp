/* micro-gemm RACE: neighboring workers share an output index.
 *
 * Mutation of partition-free.c: the slot index is halved, so two workers
 * store to the same output element.
 *
 * Dual: partition-free.c.  Expected: UNRESOLVED (real race).
 */

#include <stdint.h>
#include <pthread.h>

int output_c[4];

void *slot_worker(void *arg) {
    int index = (int)(intptr_t)arg;

    output_c[index] = 4; // RACE!
    return NULL;
}

int main(void) {
    pthread_t threads[4];

    for (int i = 0; i < 4; i++)
        pthread_create(&threads[i], NULL, slot_worker, (void *)(intptr_t)(i / 2)); // may fail
    for (int i = 0; i < 4; i++)
        pthread_join(threads[i], NULL); // may fail
    return 0;
}
