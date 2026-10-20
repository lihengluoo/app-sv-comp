// This file is part of the SV-Benchmarks collection of verification tasks:
// https://gitlab.com/sosy-lab/benchmarking/sv-benchmarks
//
// SPDX-FileCopyrightText: 2023 University of Tartu
//
// SPDX-License-Identifier: MIT

// Per-thread array pointers passed via argument but initialized before thread create.
// Extracted from silver searcher.
#include <stdlib.h>
#include <pthread.h>

void *thread(void *arg) {
  int *p = arg;
  int i = *p; // NORACE
  return NULL;
}

int main() {
  int threads_total = rand();

  pthread_t *tids = malloc(threads_total * sizeof(pthread_t));
  int *is = malloc(threads_total * sizeof(int));

  // create threads
  for (int i = 0; i < threads_total; i++) {
    is[i] = i; // NORACE
    pthread_create(&tids[i], NULL, &thread, &is[i]); // may fail but doesn't matter
  }

  // join threads
  for (int i = 0; i < threads_total; i++) {
    pthread_join(tids[i], NULL);
  }

  free(tids);
  free(is);

  return 0;
}
