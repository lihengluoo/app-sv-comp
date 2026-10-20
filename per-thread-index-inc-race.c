// This file is part of the SV-Benchmarks collection of verification tasks:
// https://gitlab.com/sosy-lab/benchmarking/sv-benchmarks
//
// SPDX-FileCopyrightText: 2023 University of Tartu
//
// SPDX-License-Identifier: MIT

// Per-thread array index using counter increment.
// Extracted from concrat/ProcDump-for-Linux.
#include <stdlib.h>
#include <pthread.h>
#include <strings.h>

int *datas;

int next_j = 0;

void *thread(void *arg) {
  int j;
  j = next_j; // RACE!
  next_j++; // RACE!

  datas[j] = rand(); // RACE!
  return NULL;
}

int main() {
  int threads_total = rand();

  pthread_t *tids = malloc(threads_total * sizeof(pthread_t));
  datas = malloc(threads_total * sizeof(int));

  // create threads
  for (int i = 0; i < threads_total; i++) {
    pthread_create(&tids[i], NULL, &thread, NULL); // may fail but doesn't matter
  }

  // join threads
  for (int i = 0; i < threads_total; i++) {
    pthread_join(tids[i], NULL);
  }

  free(tids);
  free(datas);

  return 0;
}
