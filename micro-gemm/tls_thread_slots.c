/* micro-gemm: per-thread buffers through thread-local slots.
 *
 * Distilled from applications/gemm: memory.c gives every thread its own
 * buffer table reached through thread-local storage (llvm.threadlocal
 * lowering of __thread in this build), allocated lazily per thread.
 * Each worker lazily allocates its own slot with calloc and computes its
 * gemm slice through it.
 *
 * Dual: tls_thread_slots_race.c.  Expected: DRF.
 */

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>

enum { rows_m = 64, cols_n = 64, depth_k = 64, thread_count = 4,
       alpha_scale = 2, beta_scale = 5 };

static int8_t input_a[rows_m * depth_k];
static int8_t input_b[cols_n * depth_k];
static int32_t output_c[rows_m * cols_n];
static int32_t ref_c[rows_m * cols_n];

/* One private slot per thread, reached through thread-local storage. */
static __thread int32_t *tls_slot = NULL;

struct column_range {
    int64_t from;
    int64_t to;
};

static struct column_range ranges[thread_count];

static void fill_inputs(void) {
    for (int64_t m = 0; m < rows_m; m++)
        for (int64_t k = 0; k < depth_k; k++)
            input_a[m * depth_k + k] = (int8_t)(((m * 7 + k * 3) % 11) - 5);
    for (int64_t n = 0; n < cols_n; n++)
        for (int64_t k = 0; k < depth_k; k++)
            input_b[n * depth_k + k] = (int8_t)(((n * 5 + k * 3) % 13) - 6);
}

static void *range_worker(void *arg) {
    struct column_range *range = arg;

    if (tls_slot == NULL) {
        tls_slot = aligned_alloc(64, (size_t)rows_m * sizeof *tls_slot);
        if (tls_slot == NULL) exit(1);
    }

    for (int64_t n = range->from; n < range->to; n++) {
        for (int64_t m = 0; m < rows_m; m++) {
            int32_t sum = 0;

            for (int64_t k = 0; k < depth_k; k++)
                sum += input_a[m * depth_k + k] * input_b[n * depth_k + k];
            tls_slot[m] = sum;
        }
        for (int64_t m = 0; m < rows_m; m++)
            output_c[m * cols_n + n] = output_c[m * cols_n + n] * beta_scale +
                                       alpha_scale * tls_slot[m];
    }
    return NULL;
}

int main(void) {
    pthread_t threads[thread_count];
    int64_t remaining = cols_n;
    int64_t next_from = 0;

    fill_inputs();
    memset(output_c, 1, sizeof output_c);

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
            printf("FAIL tls_thread_slots\n");
            return 1;
        }
    printf("PASS tls_thread_slots\n");
    return 0;
}
