// GEMM row partitioning, but each later job starts one row too early.
// Adjacent jobs update the same output row without synchronization.
#include <pthread.h>

int matrix_a[7][5];
int matrix_b[5][3];
int matrix_c[7][3];

void *run_job(void *ptr)
{
    int *row_range = ptr;
    int column_count = sizeof(matrix_c[0]) / sizeof(matrix_c[0][0]);
    int depth_count = sizeof(matrix_a[0]) / sizeof(matrix_a[0][0]);

    for (int row = row_range[0]; row < row_range[1]; ++row)
        for (int col = 0; col < column_count; ++col) {
            int sum = 0;
            for (int k = 0; k < depth_count; ++k)
                sum += matrix_a[row][k] * matrix_b[k][col];
            matrix_c[row][col] = sum; // RACE!
        }
    return NULL;
}

int main(void)
{
    int row_count = sizeof(matrix_c) / sizeof(matrix_c[0]);
    int column_count = sizeof(matrix_c[0]) / sizeof(matrix_c[0][0]);
    int depth_count = sizeof(matrix_a[0]) / sizeof(matrix_a[0][0]);
    int row_ranges[3][2];
    pthread_t threads[sizeof(row_ranges) / sizeof(row_ranges[0])];
    int job_count = sizeof(row_ranges) / sizeof(row_ranges[0]);
    int row_begin = 0;

    if (job_count > row_count) job_count = row_count;

    for (int row = 0; row < row_count; ++row)
        for (int k = 0; k < depth_count; ++k)
            matrix_a[row][k] = row + k + 1;
    for (int k = 0; k < depth_count; ++k)
        for (int col = 0; col < column_count; ++col)
            matrix_b[k][col] = k + col + 1;

    for (int job_id = 0; job_id < job_count; ++job_id) {
        int jobs_left = job_count - job_id;
        int width = (row_count - row_begin + jobs_left - 1) / jobs_left;

        row_ranges[job_id][0] = job_id == 0 ? row_begin : row_begin - 1;
        row_ranges[job_id][1] = row_begin + width;
        row_begin += width;
    }

    // The caller runs job zero; the remaining jobs run on pthread workers.
    for (int job_id = 1; job_id < job_count; ++job_id)
        pthread_create(&threads[job_id], NULL, run_job, row_ranges[job_id]);
    run_job(row_ranges[0]);
    for (int job_id = 1; job_id < job_count; ++job_id)
        pthread_join(threads[job_id], NULL);
    return 0;
}
