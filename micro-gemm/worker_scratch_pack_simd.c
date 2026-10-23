/* micro-gemm SIMD: per-worker private packed scratch, VNNI kernel.
 *
 * The worker_private_scratch pattern with the AVX-512 VNNI kernel and
 * the 4509y packing discipline: each worker copies its B column into a
 * privately allocated, alignment-checked buffer and computes from that
 * copy, with the sfence before free that the memory-release path uses.
 *
 * Dual: worker_scratch_pack_simd_race.c.  Expected: DRF.
 */

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <immintrin.h>

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

__attribute__((target("avx512f,avx512bw,avx512vl,avx512vnni")))
static int32_t simd_dot_packed(const int8_t *a_row, const int8_t *packed_column) {
    __m512i a_low = _mm512_cvtepi8_epi16(_mm256_loadu_si256((const __m256i *)a_row));
    __m512i b_low = _mm512_cvtepi8_epi16(_mm256_loadu_si256((const __m256i *)packed_column));
    __m512i a_high = _mm512_cvtepi8_epi16(_mm256_loadu_si256((const __m256i *)(a_row + 32)));
    __m512i b_high = _mm512_cvtepi8_epi16(_mm256_loadu_si256((const __m256i *)(packed_column + 32)));
    __m512i acc = _mm512_dpwssd_epi32(_mm512_setzero_si512(), a_low, b_low);

    acc = _mm512_dpwssd_epi32(acc, a_high, b_high);
    return _mm512_reduce_add_epi32(acc);
}

static void compute_range_packed(int64_t from, int64_t to) {
    int8_t *packed_column = aligned_alloc(64, (size_t)depth_k);

    if (packed_column == NULL) exit(1);
    if (((uintptr_t)packed_column & 63u) != 0) abort();

    for (int64_t n = from; n < to; n++) {
        memcpy(packed_column, &input_b[n * depth_k], (size_t)depth_k);
        for (int64_t m = 0; m < rows_m; m++)
            output_c[m * cols_n + n] *= beta_scale;
        for (int64_t m = 0; m < rows_m; m++)
            output_c[m * cols_n + n] += alpha_scale *
                simd_dot_packed(&input_a[m * depth_k], packed_column);
    }

    __builtin_ia32_sfence();
    free(packed_column);
}

static void *range_worker(void *arg) {
    struct column_range *range = arg;

    compute_range_packed(range->from, range->to);
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
            printf("FAIL worker_scratch_pack_simd\n");
            return 1;
        }
    printf("PASS worker_scratch_pack_simd\n");
    return 0;
}
