// This file is part of the SV-Benchmarks collection of verification tasks:
// https://gitlab.com/sosy-lab/benchmarking/sv-benchmarks
//
// SPDX-FileCopyrightText: 2023 University of Tartu
//
// SPDX-License-Identifier: MIT

// Race-free due to GCC atomic operation.
// Extracted from concrat/klib.

// Atomic should not be race-free.

#include <stdlib.h>
#include <pthread.h>

int data;

void *thread(void *arg) {
  __sync_fetch_and_add(&data, 1); // RACE
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
