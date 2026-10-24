/* micro-gemm RACE: the next call starts before the previous call joins.
 *
 * Mutation of sequential_calls.c: the second call's workers are created
 * before the first call's workers are joined, so two worker generations
 * compute the same output columns concurrently.  Both calls keep their
 * own descriptor and handle arrays; the only race is on the shared
 * output columns.
 *
 * Dual: sequential_calls.c.  Expected: UNRESOLVED (real race).
 */

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>

#define rows_m 64
#define cols_n 64
#define depth_k 64
#define thread_count 4

int8_t input_a[rows_m * depth_k];
int8_t input_b[cols_n * depth_k];
int32_t output_c[rows_m * cols_n];

struct column_range {
    int64_t from;
    int64_t to;
    int32_t alpha;
    int32_t beta;
};

struct column_range first_ranges[thread_count];
struct column_range second_ranges[thread_count];
pthread_t first_threads[thread_count];
pthread_t second_threads[thread_count];

void *range_worker(void *arg) {
    struct column_range *range = arg;

    for (int64_t n = range->from; n < range->to; n++)
        for (int64_t m = 0; m < rows_m; m++) {
            int32_t sum = 0;

            for (int64_t k = 0; k < depth_k; k++)
                sum += input_a[m * depth_k + k] * input_b[n * depth_k + k];
            if (range->beta != 0)
                output_c[m * cols_n + n] = output_c[m * cols_n + n] * range->beta +
                                           range->alpha * sum;    // RACE! overlapping calls
            else
                output_c[m * cols_n + n] = range->alpha * sum;     // RACE! overlapping calls
        }
    return NULL;
}

void start_call(struct column_range *ranges, pthread_t *threads,
                       int32_t alpha, int32_t beta) {
    int64_t remaining = cols_n;
    int64_t next_from = 0;

    for (int64_t i = 0; i < thread_count; i++) {
        int64_t width = (remaining + thread_count - i - 1) / (thread_count - i);

        ranges[i].from = next_from;
        ranges[i].to = next_from + width;
        ranges[i].alpha = alpha;
        ranges[i].beta = beta;
        next_from += width;
        remaining -= width;
    }

    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_create(&threads[i], NULL, range_worker, &ranges[i]) != 0) exit(1);
}

int main(void) {
    for (int64_t m = 0; m < rows_m; m++)
        for (int64_t k = 0; k < depth_k; k++)
            input_a[m * depth_k + k] = (int8_t)(((m * 7 + k * 3) % 11) - 5);
    for (int64_t n = 0; n < cols_n; n++)
        for (int64_t k = 0; k < depth_k; k++)
            input_b[n * depth_k + k] = (int8_t)(((n * 5 + k * 3) % 13) - 6);
    memset(output_c, 1, sizeof output_c);

    start_call(first_ranges, first_threads, 2, 0);
    start_call(second_ranges, second_threads, 3, 1);               // RACE! no join between calls

    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_join(first_threads[i], NULL) != 0) return 1;
    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_join(second_threads[i], NULL) != 0) return 1;

    printf("DONE sequential_calls_race\n");
    return 0;
}
