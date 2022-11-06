#include <pthread.h>
#include <stdlib.h>

typedef struct cond_barrier {
  unsigned int actual;
  unsigned int cantidad;
  pthread_mutex_t mut;
} cond_barrier;

int cond_barrier_init(cond_barrier* barr, unsigned int cantidad) {
  barr = (cond_barrier*)malloc(sizeof(cond_barrier));
  barr->actual = 0;
  barr->cantidad = cantidad;
  barr->mut = PTHREAD_MUTEX_INITIALIZER;

  return cantidad;
}

int cond_barrier_wait(cond_barrier* barr) {
  barr->actual++;
  if (barr->actual != barr->cantidad) {
    pthread_mutex_lock(&barr->mut);
  } else {
    pthread_mutex_unlock(&barr->mut);
  }

  return barr->actual;
}

int cond_barrier_destroy(cond_barrier* barr) {
  free(barr);
  return 0;
}
