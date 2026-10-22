/* micro-gemm: lazy one-time initialization behind a mutex.
 *
 * Distilled from applications/gemm: memory.c blas_memory_alloc guards the
 * one-time memory-system setup with alloc_lock plus an atomic
 * memory_initialized fast path; after publication every thread reads the
 * shared tables concurrently.  Here a shared scale table is filled once
 * under a mutex and then read by all workers.
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

static int64_t scale_table[depth];
static _Atomic int table_ready = 0;
static pthread_mutex_t table_mutex = PTHREAD_MUTEX_INITIALIZER;

struct column_range {
    int64_t from;
    int64_t to;
};

static struct column_range ranges[thread_count];

static void fill_inputs(void) {
    for (int64_t r = 0; r < rows; r++)
        for (int64_t k = 0; k < depth; k++)
            input_a[r * depth + k] = (int8_t)(((r * 7 + k * 3) % 11) - 5);
    for (int64_t k = 0; k < depth; k++)
        for (int64_t c = 0; c < columns; c++)
            input_b[k * columns + c] = (int8_t)(((k * 5 + c * 3) % 13) - 6);
}

static void ensure_scale_table(void) {
    if (atomic_load_explicit(&table_ready, memory_order_acquire)) return;

    pthread_mutex_lock(&table_mutex);
    if (!atomic_load(&table_ready)) {
        for (int64_t k = 0; k < depth; k++) scale_table[k] = k + 1;
        atomic_store_explicit(&table_ready, 1, memory_order_release);
    }
    pthread_mutex_unlock(&table_mutex);
}

static void *range_worker(void *arg) {
    struct column_range *range = arg;

    ensure_scale_table();

    for (int64_t col = range->from; col < range->to; col++)
        for (int64_t row = 0; row < rows; row++) {
            int32_t sum = 0;
            for (int64_t k = 0; k < depth; k++)
                sum += (int32_t)(input_a[row * depth + k] * input_b[k * columns + col]) *
                       (int32_t)scale_table[k];
            output[row * columns + col] = sum;
        }
    return NULL;
}

int main(void) {
    pthread_t threads[thread_count];
    int64_t remaining = columns;
    int64_t next_from = 0;

    fill_inputs();

    for (int64_t i = 0; i < thread_count; i++) {
        int64_t width = (remaining + thread_count - i - 1) / (thread_count - i);

        ranges[i].from = next_from;
        ranges[i].to = next_from + width;
        next_from += width;
        remaining -= width;
    }

    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_create(&threads[i], NULL, range_worker, &ranges[i]) != 0) return 1;
    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_join(threads[i], NULL) != 0) return 1;

    for (int64_t col = 0; col < columns; col++)
        for (int64_t row = 0; row < rows; row++) {
            int32_t sum = 0;
            for (int64_t k = 0; k < depth; k++)
                sum += (int32_t)(input_a[row * depth + k] * input_b[k * columns + col]) *
                       (int32_t)(k + 1);
            ref_output[row * columns + col] = sum;
        }

    for (int64_t i = 0; i < rows * columns; i++)
        if (output[i] != ref_output[i]) {
            printf("FAIL init_once_mutex\n");
            return 1;
        }
    printf("PASS init_once_mutex\n");
    return 0;
}
