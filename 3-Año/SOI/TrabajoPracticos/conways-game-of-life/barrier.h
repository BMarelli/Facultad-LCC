#if !defined(__BARRIER__)
#define __BARRIER__

#include <pthread.h>

typedef struct {
  pthread_mutex_t mutex;
  pthread_cond_t cond;
  unsigned int target;
  unsigned int current;
  void (*callback)(void *);
  void *callback_args;
} barrier_t;

// Recibe la cantidad de hilos que deben llegar a la barrera, un puntero a una función y un puntero a una estructura.
// Devuelve una barrera.
barrier_t *barrier_init(unsigned int target, void (*callback)(void *), void *callback_args);

// Recibe un puntero a una barrera, incrementa current y espera a que current sea igual a target para continuar.
// El último hilo que llega a la barrera ejecuta la función callback con la estructura callback_args como argumento.
void barrier_wait(barrier_t *barrier);

// Recibe un puntero a una barrera.
// La destruye.
void barrier_destroy(barrier_t *barrier);

#endif
