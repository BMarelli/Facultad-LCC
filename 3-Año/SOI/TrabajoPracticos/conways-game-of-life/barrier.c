#include "barrier.h"

#include <stdlib.h>

barrier_t *barrier_init(unsigned int count, void (*callback)(void *), void *callback_args) {
  barrier_t *barrier = malloc(sizeof(barrier_t));

  barrier->target = count;
  barrier->current = 0;
  barrier->callback = callback;
  barrier->callback_args = callback_args;

  pthread_mutex_init(&barrier->mutex, NULL);
  pthread_cond_init(&barrier->cond, NULL);

  return barrier;
}

void barrier_wait(barrier_t *barrier) {
  pthread_mutex_lock(&barrier->mutex);
  barrier->current++;

  if (barrier->current == barrier->target) {
    barrier->current = 0;
    barrier->callback(barrier->callback_args);
    pthread_cond_broadcast(&barrier->cond);
  } else
    pthread_cond_wait(&barrier->cond, &barrier->mutex);

  pthread_mutex_unlock(&barrier->mutex);
}

void barrier_destroy(barrier_t *barrier) { free(barrier); }
