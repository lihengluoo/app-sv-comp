// This file is part of the SV-Benchmarks collection of verification tasks:
// https://gitlab.com/sosy-lab/benchmarking/sv-benchmarks
//
// SPDX-FileCopyrightText: 2023 University of Tartu
//
// SPDX-License-Identifier: MIT

// Thread-local variable flow-sensitive value analysis.
// Extracted from silver searcher.
#include <stdlib.h>
#include <pthread.h>
#include <assert.h>
void __VERIFIER_assert(int cond) {
  assert(cond);
}

__thread int data = 0;

void *thread(void *arg) {
  __VERIFIER_assert(data == 0); // NORACE
  data = 1; // NORACE
  __VERIFIER_assert(data == 1); // NORACE
  __VERIFIER_assert(data != 0); // NORACE
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
