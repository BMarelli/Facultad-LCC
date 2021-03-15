#include <stdlib.h>

typedef struct {
  int valor;
} sem_t;

int sem_init(sem_t *sem, int init) {
  sem = (sem_t *)malloc(sizeof(sem_t));
  sem->valor = init;

  return sem->valor;
}

int sem_inc(sem_t *sem) {
  sem->valor++;

  return sem->valor;
}

int sem_decr(sem_t *sem) {
  int actual = sem->valor;
  sem->valor--;

  if (sem->valor < 0)
    while (sem->valor < actual)
      ;

  return sem->valor;
}

int sem_destroy(sem_t *sem) {
  free(sem);
  return 0;
}
