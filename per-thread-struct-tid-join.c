// This file is part of the SV-Benchmarks collection of verification tasks:
// https://gitlab.com/sosy-lab/benchmarking/sv-benchmarks
//
// SPDX-FileCopyrightText: 2023 University of Tartu
//
// SPDX-License-Identifier: MIT

// Per-thread structs containing thread ID passed via argument.
// Extracted from chrony.
#include <stdlib.h>
#include <pthread.h>

struct thread {
  pthread_t tid;
};

int data = 0;
pthread_mutex_t data_mutex = PTHREAD_MUTEX_INITIALIZER;

void *thread(void *arg) {
  pthread_mutex_lock(&data_mutex);
  data = rand(); // NORACE
  pthread_mutex_unlock(&data_mutex);
  return NULL;
}

int main() {
  int threads_total = rand();

  struct thread **ts = malloc(threads_total * sizeof(struct thread *));

  // create threads
  for (int i = 0; i < threads_total; i++) {
    struct thread *t = malloc(sizeof(struct thread));
    ts[i] = t;
    pthread_create(&t->tid, NULL, &thread, t); // may fail but doesn't matter
  }

  // join threads
  for (int i = 0; i < threads_total; i++) {
    pthread_join(ts[i]->tid, NULL);
    free(ts[i]);
  }

  free(ts);

  return data; // NORACE (all thread stopped)
}
