// This file is part of the SV-Benchmarks collection of verification tasks:
// https://gitlab.com/sosy-lab/benchmarking/sv-benchmarks
//
// SPDX-FileCopyrightText: 2023 University of Tartu
//
// SPDX-License-Identifier: MIT

// Thread pool joining via threads alive counter incremented outside of thread.
// Extracted from concrat/nnn.
#include <stdlib.h>
#include <pthread.h>

int threads_alive = 0;

int data = 0;
pthread_mutex_t data_mutex = PTHREAD_MUTEX_INITIALIZER;

void *thread(void *arg) {
  pthread_mutex_lock(&data_mutex);
  data = rand(); // RACE!
  pthread_mutex_unlock(&data_mutex);

  threads_alive--; // RACE!
  return NULL;
}

int main() {
  int threads_total = rand();

  // create threads
  for (int i = 0; i < threads_total; i++) {
    threads_alive++; // RACE!

    pthread_t tid;
    pthread_create(&tid, NULL, &thread, NULL); // may fail but doesn't matter
    pthread_detach(tid);
  }

  // wait for all threads to stop
  while (threads_alive); // RACE!

  return data; // RACE! (all threads may not have stopped due to lost increments)
}
