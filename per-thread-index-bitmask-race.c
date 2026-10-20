// This file is part of the SV-Benchmarks collection of verification tasks:
// https://gitlab.com/sosy-lab/benchmarking/sv-benchmarks
//
// SPDX-FileCopyrightText: 2023 University of Tartu
//
// SPDX-License-Identifier: MIT

// Per-thread array index using bitmask passed via argument.
// Extracted from concrat/nnn.
#include <stdlib.h>
#include <pthread.h>
#include <strings.h>

int threads_mask = -1; // all bits 1

int *datas;

void *thread(void *arg) {
  int j = (int)arg;
  datas[j] = 4; // RACE!

  // change j-th bit back to 1
  threads_mask |= 1 << j; // RACE!
  return NULL;
}

int main() {
  int threads_total = 4;

  pthread_t *tids = malloc(threads_total * sizeof(pthread_t));
  datas = malloc(threads_total * sizeof(int));

  // create threads
  for (int i = 0; i < threads_total; i++) {
    // find first 1 bit index
    int j = ffs(threads_mask) - 1; // RACE!
    // change j-th bit to 0
    threads_mask &= ~(1 << j); // RACE!

    pthread_create(&tids[i], NULL, &thread, (void*)j); // may fail but doesn't matter
  }

  // join threads
  for (int i = 0; i < threads_total; i++) {
    pthread_join(tids[i], NULL);
  }

  free(tids);
  free(datas);

  return 0;
}
