/* micro-gemm SIMD RACE: adjacent VNNI slices overlap by one column.
 *
 * Mutation of partition_columns_simd.c: every worker's range includes
 * one column too many, so neighbors run the VNNI kernel accumulate on
 * the boundary column concurrently.
 *
 * Dual: partition_columns_simd.c.  Expected: UNRESOLVED (real race).
 */

#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <pthread.h>
#include <immintrin.h>

enum { rows_m = 64, cols_n = 64, depth_k = 64, thread_count = 4,
       alpha_scale = 2, beta_scale = 5 };

static int8_t input_a[rows_m * depth_k];
static int8_t input_b[cols_n * depth_k];
static int32_t output_c[rows_m * cols_n];

struct column_range {
    int64_t from;
    int64_t to;
};

static struct column_range ranges[thread_count];

__attribute__((target("avx512f,avx512bw,avx512vl,avx512vnni")))
static int32_t simd_dot_column(const int8_t *a_row, const int8_t *b_col) {
    __m512i a_low = _mm512_cvtepi8_epi16(_mm256_loadu_si256((const __m256i *)a_row));
    __m512i b_low = _mm512_cvtepi8_epi16(_mm256_loadu_si256((const __m256i *)b_col));
    __m512i a_high = _mm512_cvtepi8_epi16(_mm256_loadu_si256((const __m256i *)(a_row + 32)));
    __m512i b_high = _mm512_cvtepi8_epi16(_mm256_loadu_si256((const __m256i *)(b_col + 32)));
    __m512i acc = _mm512_dpwssd_epi32(_mm512_setzero_si512(), a_low, b_low);

    acc = _mm512_dpwssd_epi32(acc, a_high, b_high);
    return _mm512_reduce_add_epi32(acc);
}

__attribute__((target("avx512f,avx512bw,avx512vl,avx512vnni")))
static void gemm_column_simd(int64_t n) {
    for (int64_t m = 0; m < rows_m; m++)
        output_c[m * cols_n + n] *= beta_scale;                   // RACE! shared column
    for (int64_t m = 0; m < rows_m; m++)
        output_c[m * cols_n + n] += alpha_scale *                 // RACE! shared column
            simd_dot_column(&input_a[m * depth_k], &input_b[n * depth_k]);
}

static void *range_worker(void *arg) {
    struct column_range *range = arg;

    for (int64_t n = range->from; n < range->to; n++)             // RACE! over-wide to
        gemm_column_simd(n);
    return NULL;
}

int main(void) {
    pthread_t threads[thread_count];
    const int64_t width = cols_n / thread_count;

    for (int64_t m = 0; m < rows_m; m++)
        for (int64_t k = 0; k < depth_k; k++)
            input_a[m * depth_k + k] = (int8_t)(((m * 7 + k * 3) % 11) - 5);
    for (int64_t n = 0; n < cols_n; n++)
        for (int64_t k = 0; k < depth_k; k++)
            input_b[n * depth_k + k] = (int8_t)(((n * 5 + k * 3) % 13) - 6);
    memset(output_c, 1, sizeof output_c);

    for (int64_t i = 0; i < thread_count; i++) {
        ranges[i].from = i * width;
        ranges[i].to = (i == thread_count - 1) ? cols_n : (i + 1) * width + 1;
    }

    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_create(&threads[i], NULL, range_worker, &ranges[i]) != 0) return 1;
    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_join(threads[i], NULL) != 0) return 1;

    printf("DONE partition_columns_simd_race\n");
    return 0;
}
