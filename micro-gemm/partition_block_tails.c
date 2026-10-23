/* micro-gemm: disjoint partition walked in blocks with tail loops.
 *
 * Distilled from applications/gemm: level3.c walks each worker's N range
 * in min_jj column chunks and the k dimension in chunks with remainder
 * tails, so stores stay disjoint through nested block loops and
 * min-step bounds.  The block ends use the min idiom that lowers to
 * llvm.umin exactly like level3.c's min_jj bound.
 *
 * Dual: partition_block_tails_race.c.  Expected: DRF.
 */

#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <pthread.h>

enum { rows_m = 64, cols_n = 61, depth_k = 61, thread_count = 4,
       column_block = 7, depth_block = 4,
       alpha_scale = 2, beta_scale = 5 };

static int8_t input_a[rows_m * depth_k];
static int8_t input_b[cols_n * depth_k];
static int32_t output_c[rows_m * cols_n];
static int32_t ref_c[rows_m * cols_n];

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

/* One output column with the k dimension walked in chunks plus a
   remainder tail, the kernel-side loop shape of level3.c. */
static void gemm_column_blocked(int32_t *dst, int64_t n) {
    for (int64_t m = 0; m < rows_m; m++)
        dst[m * cols_n + n] *= beta_scale;
    for (int64_t m = 0; m < rows_m; m++) {
        int32_t sum = 0;

        for (int64_t chunk = 0; chunk < depth_k / depth_block; chunk++)
            for (int64_t step = 0; step < depth_block; step++) {
                int64_t k = chunk * depth_block + step;

                sum += input_a[m * depth_k + k] * input_b[n * depth_k + k];
            }
        for (int64_t k = depth_k - depth_k % depth_block; k < depth_k; k++)
            sum += input_a[m * depth_k + k] * input_b[n * depth_k + k];
        dst[m * cols_n + n] += alpha_scale * sum;
    }
}

static void compute_columns(int64_t from, int64_t to) {
    for (int64_t block_from = from; block_from < to; block_from += column_block) {
        int64_t block_to = block_from + column_block;

        if (block_to > to) block_to = to; /* min idiom -> llvm.umin */
        for (int64_t n = block_from; n < block_to; n++)
            gemm_column_blocked(output_c, n);
    }
}

static void *range_worker(void *arg) {
    struct column_range *range = arg;

    compute_columns(range->from, range->to);
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
            printf("FAIL partition_block_tails\n");
            return 1;
        }
    printf("PASS partition_block_tails\n");
    return 0;
}
