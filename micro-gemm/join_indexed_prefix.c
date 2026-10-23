/* micro-gemm: indexed create/join over the successful prefix.
 *
 * Distilled from applications/gemm: exec_blas keeps a pthread_t array,
 * creates one worker per queued job, joins each created handle, and the
 * single-worker case makes both loops zero-iteration.  pthread_create
 * failure shrinks the joined prefix; the caller computes the remaining
 * gemm slices inline.
 *
 * Dual: join_indexed_prefix_race.c.  Expected: DRF.
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

static void gemm_column(int64_t n) {
    for (int64_t m = 0; m < rows_m; m++)
        output_c[m * cols_n + n] *= beta_scale;
    for (int64_t m = 0; m < rows_m; m++) {
        int32_t sum = 0;

        for (int64_t k = 0; k < depth_k; k++)
            sum += input_a[m * depth_k + k] * input_b[n * depth_k + k];
        output_c[m * cols_n + n] += alpha_scale * sum;
    }
}

static void *range_worker(void *arg) {
    struct column_range *range = arg;

    for (int64_t n = range->from; n < range->to; n++)
        gemm_column(n);
    return NULL;
}

int main(void) {
    pthread_t threads[thread_count];
    int64_t created = 0;
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

    for (int64_t i = 0; i < thread_count; i++) {
        if (pthread_create(&threads[i], NULL, range_worker, &ranges[i]) != 0) break;
        created++;
    }

    for (int64_t i = 0; i < created; i++)
        if (pthread_join(threads[i], NULL) != 0) return 1;

    if (__builtin_expect(created < thread_count, 0)) {
        for (int64_t i = created; i < thread_count; i++)
            for (int64_t n = ranges[i].from; n < ranges[i].to; n++)
                gemm_column(n);
    }

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
            printf("FAIL join_indexed_prefix\n");
            return 1;
        }
    printf("PASS join_indexed_prefix\n");
    return 0;
}
