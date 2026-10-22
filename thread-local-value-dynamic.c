// This file is part of the SV-Benchmarks collection of verification tasks:
// https://gitlab.com/sosy-lab/benchmarking/sv-benchmarks
//
// SPDX-FileCopyrightText: 2023 University of Tartu
//
// SPDX-License-Identifier: MIT

// Thread-local variable flow-sensitive value analysis with dynamic allocation.
// Extracted from silver searcher.
#include <stdlib.h>
#include <pthread.h>
#include <assert.h>
void __VERIFIER_assert(int cond) {
  assert(cond);
}

__thread int* data = NULL;

void *thread(void *arg) {
  int n = 4;

  data = calloc(n, sizeof(int)); // NORACE

  for (int i = 0; i < n; i++) {
    __VERIFIER_assert(data[i] == 0); // NORACE
  }

  for (int i = 0; i < n; i++) {
    data[i] = 1; // NORACE
  }

  free(data); // NORACE
  return NULL;
}

int main() {
  int threads_total = 4;

  pthread_t *tids = malloc(threads_total * sizeof(pthread_t));

  // create threads
  for (int i = 0; i < threads_total; i++) {
    pthread_create(&tids[i], NULL, &thread, NULL); // may fail but doesn't matter
  }

  // join threads
  for (int i = 0; i < threads_total; i++) {
    pthread_join(tids[i], NULL);
  }

  free(tids);

  return 0;
}
