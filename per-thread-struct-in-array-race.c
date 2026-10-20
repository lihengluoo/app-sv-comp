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
#include <stdint.h>
extern void abort(void);
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
extern int __VERIFIER_nondet_int();

struct thread {
  int data;
};

void *thread(void *arg) {
  struct thread *t = arg;
  t->data = __VERIFIER_nondet_int(); // RACE!
  return NULL;
}

int main() {
  int threads_total = __VERIFIER_nondet_int();
  assume_abort_if_not(threads_total >= 0);

  assume_abort_if_not(threads_total <= SIZE_MAX / sizeof(pthread_t));
  pthread_t *tids = safe_malloc(threads_total * sizeof(pthread_t));
  assume_abort_if_not(threads_total <= SIZE_MAX / sizeof(struct thread));
  struct thread *ts = safe_malloc(threads_total * sizeof(struct thread));

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
