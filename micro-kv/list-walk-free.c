// Linked-list walk under a mutex, distilled from applications/kv kvs_get.
// All state travels through the thread argument; sizes are plain locals.
#include <stdlib.h>
#include <pthread.h>

struct node {
  struct node *next;
  int data;
};

struct list {
  pthread_mutex_t mutex;
  struct node *head;
};

void *thread(void *arg) {
  struct list *list = arg;
  pthread_mutex_lock(&list->mutex);
  for (struct node *node = list->head; node != NULL; node = node->next)
    node->data += 1; // NORACE
  pthread_mutex_unlock(&list->mutex);
  return NULL;
}

int main() {
  int nodes_total = 4;
  int threads_total = 2;

  struct list *list = malloc(sizeof(struct list));
  pthread_mutex_init(&list->mutex, NULL);
  list->head = NULL;
  for (int i = 0; i < nodes_total; i++) {
    struct node *node = malloc(sizeof(struct node));
    node->data = 0;
    node->next = list->head;
    list->head = node;
  }

  pthread_t *tids = malloc(threads_total * sizeof(pthread_t));

  // create threads
  for (int i = 0; i < threads_total; i++)
    pthread_create(&tids[i], NULL, &thread, list); // may fail but doesn't matter

  // join threads
  for (int i = 0; i < threads_total; i++)
    pthread_join(tids[i], NULL);

  return 0;
}
