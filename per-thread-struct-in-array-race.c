// This file is part of the SV-Benchmarks collection of verification tasks:
// https://gitlab.com/sosy-lab/benchmarking/sv-benchmarks
//
// SPDX-FileCopyrightText: 2023 University of Tartu
//
// SPDX-License-Identifier: MIT

// Per-thread structs in array passed via argument.
// Extracted from concrat/ProcDump-for-Linux.
#include <stdlib.h>
#include <pthread.h>

struct thread {
  int data;
};

void *thread(void *arg) {
  struct thread *t = arg;
  t->data = rand(); // RACE!
  return NULL;
}

int main() {
  int threads_total = rand();

  pthread_t *tids = malloc(threads_total * sizeof(pthread_t));
  struct thread *ts = malloc(threads_total * sizeof(struct thread));

  // create threads
  for (int i = 0; i < threads_total; i++) {
    pthread_create(&tids[i], NULL, &thread, &ts[i / 2]); // may fail but doesn't matter
  }

  // join threads
  for (int i = 0; i < threads_total; i++) {
    pthread_join(tids[i], NULL);
  }

  free(tids);
  free(ts);

  return 0;
}
