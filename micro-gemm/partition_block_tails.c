/* micro-gemm: disjoint partition walked in blocks with tail loops.
 *
 * Distilled from applications/gemm: level3.c walks each worker's N range
 * in min_jj column chunks and the k dimension in chunks with remainder
 * tails (the kernels handle bk & 3 remainders), so stores stay disjoint
 * through nested block loops and min-step bounds.
 *
 * Expected: DRF.
 */

#include <stdint.h>
#include <stdio.h>
#include <pthread.h>

enum { rows = 64, columns = 61, depth = 46, thread_count = 4,
       column_block = 7, depth_block = 4 };

static int8_t input_a[rows * depth];
static int8_t input_b[depth * columns];
static int32_t output[rows * columns];
static int32_t ref_output[rows * columns];

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

static void compute_block(int64_t col_from, int64_t col_to) {
    for (int64_t col = col_from; col < col_to; col++)
        for (int64_t row = 0; row < rows; row++) {
            int32_t sum = 0;

            for (int64_t k = 0; k < depth / depth_block; k++)
                for (int64_t step = 0; step < depth_block; step++) {
                    int64_t kk = k * depth_block + step;
                    sum += input_a[row * depth + kk] * input_b[kk * columns + col];
                }
            for (int64_t kk = depth - depth % depth_block; kk < depth; kk++)
                sum += input_a[row * depth + kk] * input_b[kk * columns + col];

            output[row * columns + col] = sum;
        }
}

static void compute_columns(int64_t from, int64_t to) {
    int64_t full_blocks = (to - from) / column_block;

    for (int64_t block = 0; block < full_blocks; block++) {
        int64_t block_from = from + block * column_block;
        compute_block(block_from, block_from + column_block);
    }
    compute_block(from + full_blocks * column_block, to);
}

static void *range_worker(void *arg) {
    struct column_range *range = arg;
    compute_columns(range->from, range->to);
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
                sum += input_a[row * depth + k] * input_b[k * columns + col];
            ref_output[row * columns + col] = sum;
        }

    for (int64_t i = 0; i < rows * columns; i++)
        if (output[i] != ref_output[i]) {
            printf("FAIL partition_block_tails\n");
            return 1;
        }
    printf("PASS partition_block_tails\n");
    return 0;
}
