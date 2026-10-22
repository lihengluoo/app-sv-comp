/* micro-gemm: shared read-only inputs under a partitioned output.
 *
 * Distilled from applications/gemm: the A and B matrices are inputs that
 * every worker reads across the whole matrix while writing only its own
 * slice of C.  Concurrent reads of shared inputs are not races; only the
 * disjoint output slices are written.
 *
 * Expected: DRF.
 */

#include <stdint.h>
#include <stdio.h>
#include <pthread.h>

enum { rows = 64, columns = 64, depth = 48, thread_count = 4 };

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

static void *range_worker(void *arg) {
    struct column_range *range = arg;
    /* Every worker reads all of A and all of B ... */
    int32_t input_scan = 0;

    for (int64_t i = 0; i < rows * depth; i++) input_scan += input_a[i];
    for (int64_t i = 0; i < depth * columns; i++) input_scan += input_b[i];

    /* ... but writes only its own output slice. */
    for (int64_t col = range->from; col < range->to; col++)
        for (int64_t row = 0; row < rows; row++) {
            int32_t sum = 0;
            for (int64_t k = 0; k < depth; k++)
                sum += input_a[row * depth + k] * input_b[k * columns + col];
            output[row * columns + col] = sum + (input_scan * 0);
        }
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
            printf("FAIL shared_readonly_inputs\n");
            return 1;
        }
    printf("PASS shared_readonly_inputs\n");
    return 0;
}
