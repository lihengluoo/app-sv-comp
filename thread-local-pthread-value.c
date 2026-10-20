// This file is part of the SV-Benchmarks collection of verification tasks:
// https://gitlab.com/sosy-lab/benchmarking/sv-benchmarks
//
// SPDX-FileCopyrightText: 2023 University of Tartu
//
// SPDX-License-Identifier: MIT

// Thread-local pthread variable flow-sensitive value analysis.
// Extracted from concrat/pigz.
#include <stdlib.h>
#include <pthread.h>
#include <assert.h>
void reach_error() { assert(0); }
void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: {reach_error();abort();}
  }
  return;
}

pthread_key_t key;

void *thread(void *arg) {
  int x, y;
  pthread_setspecific(key, &x); // NORACE
  __VERIFIER_assert(pthread_getspecific(key) == &x); // NORACE
  pthread_setspecific(key, &y); // NORACE
  __VERIFIER_assert(pthread_getspecific(key) == &y); // NORACE
  __VERIFIER_assert(pthread_getspecific(key) != &x); // NORACE
  return NULL;
}

int main() {
  pthread_key_create(&key, NULL);

  int threads_total = rand();

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
