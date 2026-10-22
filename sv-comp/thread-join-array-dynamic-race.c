// This file is part of the SV-Benchmarks collection of verification tasks:
// https://gitlab.com/sosy-lab/benchmarking/sv-benchmarks
//
// SPDX-FileCopyrightText: 2023 University of Tartu
//
// SPDX-License-Identifier: MIT

// Thread pool dynamic array sequential joining.
// Extracted from concrat/klib, concrat/minimap2.
// Thread pool from some common library?
#include <stdlib.h>
#include <pthread.h>

int data = 0;
pthread_mutex_t data_mutex = PTHREAD_MUTEX_INITIALIZER;

void *thread(void *arg) {
  pthread_mutex_lock(&data_mutex);
  data = 4; // RACE!
  pthread_mutex_unlock(&data_mutex);
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
  for (int i = 0; i < threads_total - 1; i++) {
    pthread_join(tids[i], NULL);
  }

  free(tids);

  return data; // RACE! (last thread not joined)
}
