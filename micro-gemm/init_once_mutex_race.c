/* micro-gemm RACE: initialization fast path without the lock.
 *
 * Mutation of init_once_mutex.c: the table_ready check and the table
 * writes happen outside any lock, so two workers can fill the shared
 * scale table at the same time.
 *
 * Dual: init_once_mutex.c.  Expected: UNRESOLVED (real race).
 */

#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <pthread.h>

enum { rows_m = 64, cols_n = 64, depth_k = 64, thread_count = 4,
       alpha_scale = 2, beta_scale = 5 };

static int8_t input_a[rows_m * depth_k];
static int8_t input_b[cols_n * depth_k];
static int32_t output_c[rows_m * cols_n];

static int64_t scale_table[depth_k];
static int table_ready = 0;

struct column_range {
    int64_t from;
    int64_t to;
};

static struct column_range ranges[thread_count];

static void ensure_scale_table(void) {
    if (table_ready) return;

    for (int64_t k = 0; k < depth_k; k++) scale_table[k] = k + 1;  // RACE! unlocked init writes
    table_ready = 1;                                               // RACE! unlocked flag store
}

static void *range_worker(void *arg) {
    struct column_range *range = arg;

    ensure_scale_table();

    for (int64_t n = range->from; n < range->to; n++) {
        for (int64_t m = 0; m < rows_m; m++)
            output_c[m * cols_n + n] *= beta_scale;
        for (int64_t m = 0; m < rows_m; m++) {
            int32_t sum = 0;

            for (int64_t k = 0; k < depth_k; k++)
                sum += (int32_t)(input_a[m * depth_k + k] * input_b[n * depth_k + k]) *
                       (int32_t)scale_table[k];                    // RACE! concurrent table reads
            output_c[m * cols_n + n] += alpha_scale * sum;
        }
    }
    return NULL;
}

int main(void) {
    pthread_t threads[thread_count];
    int64_t remaining = cols_n;
    int64_t next_from = 0;

    for (int64_t m = 0; m < rows_m; m++)
        for (int64_t k = 0; k < depth_k; k++)
            input_a[m * depth_k + k] = (int8_t)(((m * 7 + k * 3) % 11) - 5);
    for (int64_t n = 0; n < cols_n; n++)
        for (int64_t k = 0; k < depth_k; k++)
            input_b[n * depth_k + k] = (int8_t)(((n * 5 + k * 3) % 13) - 6);
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

    printf("DONE init_once_mutex_race\n");
    return 0;
}
