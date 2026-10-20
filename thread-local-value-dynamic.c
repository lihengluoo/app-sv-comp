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
#include <stdint.h>
extern void abort(void);
void *safe_calloc(size_t num, size_t size) {
  void *p = calloc(num, size);
  if (p == 0) {
    abort();
  }
  return p;
}

void *safe_malloc(size_t size) {
  void *p = malloc(size);
  if (p == 0) {
    abort();
  }
  return p;
}

void assume_abort_if_not(int cond) {
  if(!cond) {abort();}
}
#include <assert.h>
void reach_error() { assert(0); }
void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: {reach_error();abort();}
  }
  return;
}
extern int __VERIFIER_nondet_int();

__thread int* data = NULL;

void *thread(void *arg) {
  int n = __VERIFIER_nondet_int();
  assume_abort_if_not(n >= 0);

  data = safe_calloc(n, sizeof(int)); // NORACE

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
  int threads_total = __VERIFIER_nondet_int();
  assume_abort_if_not(threads_total >= 0);

  assume_abort_if_not(threads_total <= SIZE_MAX / sizeof(pthread_t));
  pthread_t *tids = safe_malloc(threads_total * sizeof(pthread_t));

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
