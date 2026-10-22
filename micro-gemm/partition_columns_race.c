/* micro-gemm RACE: adjacent column slices overlap by one column.
 *
 * Mutation of partition_columns.c: every worker's range includes one
 * column too many, so neighbors write the boundary column concurrently.
 *
 * Expected: UNRESOLVED (real race).
 */

#include <stdint.h>
#include <stdio.h>
#include <pthread.h>

enum { rows = 64, columns = 64, depth = 48, thread_count = 4 };

static int8_t input_a[rows * depth];
static int8_t input_b[depth * columns];
static int32_t output[rows * columns];

struct column_range {
    int64_t from;
    int64_t to;
};

static struct column_range ranges[thread_count];

static void *range_worker(void *arg) {
    struct column_range *range = arg;

    for (int64_t col = range->from; col < range->to; col++)      // RACE! over-wide to
        for (int64_t row = 0; row < rows; row++) {
            int32_t sum = 0;
            for (int64_t k = 0; k < depth; k++)
                sum += input_a[row * depth + k] * input_b[k * columns + col];
            output[row * columns + col] = sum;                   // RACE! shared column
        }
    return NULL;
}

int main(void) {
    pthread_t threads[thread_count];
    const int64_t width = columns / thread_count;

    for (int64_t r = 0; r < rows; r++)
        for (int64_t k = 0; k < depth; k++)
            input_a[r * depth + k] = (int8_t)(((r * 7 + k * 3) % 11) - 5);
    for (int64_t k = 0; k < depth; k++)
        for (int64_t c = 0; c < columns; c++)
            input_b[k * columns + c] = (int8_t)(((k * 5 + c * 3) % 13) - 6);

    for (int64_t i = 0; i < thread_count; i++) {
        ranges[i].from = i * width;
        ranges[i].to = (i == thread_count - 1) ? columns : (i + 1) * width + 1;
    }

    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_create(&threads[i], NULL, range_worker, &ranges[i]) != 0) return 1;
    for (int64_t i = 0; i < thread_count; i++)
        if (pthread_join(threads[i], NULL) != 0) return 1;

    printf("DONE partition_columns_race\n");
    return 0;
}
