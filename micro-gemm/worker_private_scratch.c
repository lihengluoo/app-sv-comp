/* micro-gemm: per-worker private packing scratch.
 *
 * Distilled from applications/gemm: blas_server.c blas_job_thread gives
 * every worker its own buffer from blas_memory_alloc, the worker packs
 * its input slice into that private memory (memcpy), computes from it,
 * issues the sfence the memory-release path uses, and frees it before
 * returning.  The alignment guard mirrors blas_memory_alloc's abort on
 * misaligned buffers.  Nothing scratch-related is ever shared.
 *
 * Dual: worker_private_scratch_race.c.  Expected: DRF.
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
#define alpha_scale 2
#define beta_scale 5

int8_t input_a[rows_m * depth_k];
int8_t input_b[cols_n * depth_k];
int32_t output_c[rows_m * cols_n];
int32_t ref_c[rows_m * cols_n];

struct column_range {
    int64_t from;
    int64_t to;
};

struct column_range ranges[thread_count];

void fill_inputs(void) {
    for (int64_t m = 0; m < rows_m; m++)
        for (int64_t k = 0; k < depth_k; k++)
            input_a[m * depth_k + k] = (int8_t)(((m * 7 + k * 3) % 11) - 5);
    for (int64_t n = 0; n < cols_n; n++)
        for (int64_t k = 0; k < depth_k; k++)
            input_b[n * depth_k + k] = (int8_t)(((n * 5 + k * 3) % 13) - 6);
}

/* Pack one B column into the private scratch, then compute the whole
   output column from the packed copy: pack (memcpy), beta pre-scale,
   alpha-accumulate. */
/* Pack alignment as a runtime mask + 1, the same shape as memory.c's
   alloc_buffer_block: a computed alignment makes the compiler carry the
   result alignment as an llvm.assume, exactly like the app. */
volatile size_t pack_align_mask = 63;

void compute_range_packed(int64_t from, int64_t to) {
    size_t mask = (size_t)pack_align_mask;
    size_t align = mask + 1;
    int8_t *packed_column = aligned_alloc(align, ((size_t)depth_k + mask) & ~mask);

    if (packed_column == NULL) exit(1);
    if (((uintptr_t)packed_column & mask) != 0) abort();

    for (int64_t n = from; n < to; n++) {
        memcpy(packed_column, &input_b[n * depth_k], (size_t)depth_k);
        for (int64_t m = 0; m < rows_m; m++)
            output_c[m * cols_n + n] *= beta_scale;
        for (int64_t m = 0; m < rows_m; m++) {
            int32_t sum = 0;

            for (int64_t k = 0; k < depth_k; k++)
                sum += input_a[m * depth_k + k] * packed_column[k];
            output_c[m * cols_n + n] += alpha_scale * sum;
        }
    }

    __builtin_ia32_sfence();
    free(packed_column);
}

void *range_worker(void *arg) {
    struct column_range *range = arg;

    compute_range_packed(range->from, range->to);
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
            printf("FAIL worker_private_scratch\n");
            return 1;
        }
    printf("PASS worker_private_scratch\n");
    return 0;
}
