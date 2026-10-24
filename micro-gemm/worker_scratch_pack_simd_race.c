/* micro-gemm SIMD RACE: workers share one packed scratch buffer.
 *
 * Mutation of worker_scratch_pack_simd.c: the caller allocates a single
 * packed-column buffer and hands the same pointer to every worker, so
 * all workers pack and compute through the same memory concurrently.
 *
 * Dual: worker_scratch_pack_simd.c.  Expected: UNRESOLVED (real race).
 */

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <immintrin.h>

#define rows_m 64
#define cols_n 64
#define depth_k 64
#define thread_count 4
#define alpha_scale 2
#define beta_scale 5

int8_t input_a[rows_m * depth_k];
int8_t input_b[cols_n * depth_k];
int32_t output_c[rows_m * cols_n];

struct job_plan {
    int8_t *shared_packed;
    int64_t column_from;
    int64_t column_to;
};

struct job_plan plans[thread_count];

__attribute__((target("avx512f,avx512bw,avx512vl,avx512vnni")))
int32_t simd_dot_packed(const int8_t *a_row, const int8_t *packed_column) {
    __m512i a_low = _mm512_cvtepi8_epi16(_mm256_loadu_si256((const __m256i *)a_row));
    __m512i b_low = _mm512_cvtepi8_epi16(_mm256_loadu_si256((const __m256i *)packed_column));
    __m512i a_high = _mm512_cvtepi8_epi16(_mm256_loadu_si256((const __m256i *)(a_row + 32)));
    __m512i b_high = _mm512_cvtepi8_epi16(_mm256_loadu_si256((const __m256i *)(packed_column + 32)));
    __m512i acc = _mm512_dpwssd_epi32(_mm512_setzero_si512(), a_low, b_low);

    acc = _mm512_dpwssd_epi32(acc, a_high, b_high);
    return _mm512_reduce_add_epi32(acc);
}

void *plan_worker(void *arg) {
    struct job_plan *plan = arg;

    for (int64_t n = plan->column_from; n < plan->column_to; n++) {
        memcpy(plan->shared_packed, &input_b[n * depth_k], (size_t)depth_k);  // RACE! one buffer

        for (int64_t m = 0; m < rows_m; m++)
            output_c[m * cols_n + n] *= beta_scale;
        for (int64_t m = 0; m < rows_m; m++)
            output_c[m * cols_n + n] += alpha_scale *
                simd_dot_packed(&input_a[m * depth_k], plan->shared_packed); // RACE! one buffer
    }
    return NULL;
}

int main(void) {
    pthread_t threads[thread_count];
    int8_t *shared_packed = aligned_alloc(64, (size_t)depth_k);
    const int64_t width = cols_n / thread_count;

    if (shared_packed == NULL) return 1;

    for (int64_t m = 0; m < rows_m; m++)
        for (int64_t k = 0; k < depth_k; k++)
            input_a[m * depth_k + k] = (int8_t)(((m * 7 + k * 3) % 11) - 5);
    for (int64_t n = 0; n < cols_n; n++)
        for (int64_t k = 0; k < depth_k; k++)
            input_b[n * depth_k + k] = (int8_t)(((n * 5 + k * 3) % 13) - 6);
    memset(output_c, 1, sizeof output_c);

    for (int64_t i = 0; i < thread_count; i++) {
        plans[i].shared_packed = shared_packed;
        plans[i].column_from = i * width;
        plans[i].column_to = (i == thread_count - 1) ? cols_n : (i + 1) * width;
    }

    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_create(&threads[i], NULL, plan_worker, &plans[i]) != 0) return 1;
    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_join(threads[i], NULL) != 0) return 1;

    free(shared_packed);
    printf("DONE worker_scratch_pack_simd_race\n");
    return 0;
}
