// Fork/join shape of applications/gemm/lib/driver/others/blas_server.c.
// Same as thread-create-free.c, but every job updates the first slice.
#include <pthread.h>

#define job_count 3
#define slice_size 2

struct job_args {
    int output[job_count * slice_size];
};

struct job {
    struct job_args *args;
    int begin;
    int end;
    struct job *next;
};

void run_job(struct job *job)
{
    struct job_args *args = job->args;
    for (int index = job->begin; index < job->end; ++index)
        args->output[index] += 1; // RACE!
}

void *run_job_thread(void *ptr)
{
    run_job(ptr);
    return NULL;
}

void run_jobs(int num_jobs, struct job *queue)
{
    pthread_t threads[job_count - 1];
    int created = 0;

    // As in GEMM, pthread creation is assumed to succeed.
    for (struct job *job = queue->next;
         job != NULL && created < num_jobs - 1; job = job->next) {
        pthread_create(&threads[created], NULL, run_job_thread, job);
        ++created;
    }

    // The caller processes the first job concurrently with its pthreads.
    run_job(queue);

    for (int thread_id = 0; thread_id < created; ++thread_id)
        pthread_join(threads[thread_id], NULL);
}

int main(void)
{
    struct job_args args = {0};
    struct job queue[job_count];

    for (int job_id = 0; job_id < job_count; ++job_id) {
        queue[job_id].args = &args;
        queue[job_id].begin = 0;
        queue[job_id].end = queue[job_id].begin + slice_size;
        queue[job_id].next = &queue[job_id + 1];
    }
    queue[job_count - 1].next = NULL;

    run_jobs(job_count, queue);
    return 0;
}
