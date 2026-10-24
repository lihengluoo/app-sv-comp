/* micro-gemm RACE: block walk oversteps the slice by one column.
 *
 * Mutation of partition_block_tails.c: the block-end clamp allows one
 * column past the slice end, so the last block of every slice computes
 * the neighbor's first column concurrently with its owner.
 *
 * Dual: partition_block_tails.c.  Expected: UNRESOLVED (real race).
 */

#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <pthread.h>

#define rows_m 64
#define cols_n 61
#define depth_k 61
#define thread_count 4
#define column_block 7
#define depth_block 4
#define alpha_scale 2
#define beta_scale 5

int8_t input_a[rows_m * depth_k];
int8_t input_b[cols_n * depth_k];
int32_t output_c[rows_m * cols_n];

struct column_range {
    int64_t from;
    int64_t to;
};

struct column_range ranges[thread_count];

void gemm_column_blocked(int64_t n) {
    for (int64_t m = 0; m < rows_m; m++)
        output_c[m * cols_n + n] *= beta_scale;
    for (int64_t m = 0; m < rows_m; m++) {
        int32_t sum = 0;

        for (int64_t chunk = 0; chunk < depth_k / depth_block; chunk++)
            for (int64_t step = 0; step < depth_block; step++) {
                int64_t k = chunk * depth_block + step;

                sum += input_a[m * depth_k + k] * input_b[n * depth_k + k];
            }
        for (int64_t k = depth_k - depth_k % depth_block; k < depth_k; k++)
            sum += input_a[m * depth_k + k] * input_b[n * depth_k + k];
        output_c[m * cols_n + n] += alpha_scale * sum;
    }
}

void compute_columns(int64_t from, int64_t to) {
    for (int64_t block_from = from; block_from < to; block_from += column_block) {
        int64_t block_to = block_from + column_block;

        if (block_to > to + 1) block_to = to + 1;                 // RACE! clamp one past the slice
        for (int64_t n = block_from; n < block_to; n++)
            gemm_column_blocked(n);                               // RACE! neighbor's column
    }
}

void *range_worker(void *arg) {
    struct column_range *range = arg;

    compute_columns(range->from, range->to);
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

    printf("DONE partition_block_tails_race\n");
    return 0;
}
