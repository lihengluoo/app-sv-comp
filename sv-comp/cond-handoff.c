// Straight-line condvar handoff: a single worker signals one completion
// condvar after writing the payload; main waits on it before reading.
#include <stdlib.h>
#include <pthread.h>

pthread_mutex_t done_mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t done_cond = PTHREAD_COND_INITIALIZER;

int data = 0;

void *worker(void *arg) {
  data = 1; // NORACE (published by the condvar handoff)
  pthread_mutex_lock(&done_mutex);
  pthread_cond_signal(&done_cond);
  pthread_mutex_unlock(&done_mutex);
  return NULL;
}

int main() {
  pthread_t tid;
  pthread_create(&tid, NULL, &worker, NULL);

  pthread_mutex_lock(&done_mutex);
  pthread_cond_wait(&done_cond, &done_mutex);
  pthread_mutex_unlock(&done_mutex);

  return data; // NORACE (ordered after the worker's write)
}
