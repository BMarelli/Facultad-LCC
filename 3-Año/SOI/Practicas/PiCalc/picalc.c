#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
/* #include<math.h> */

#define NPoints 10000
#define NHilos 4

pthread_mutex_t mut = PTHREAD_MUTEX_INITIALIZER;

void calculo(void* cuenta) {
  double px, py;

  double cuentaLocal = 0;
  for (int i = 0; i < NPoints; i++) {
    px = (double)(random()) / (double)(RAND_MAX);
    py = (double)(random()) / (double)(RAND_MAX);
    if ((px * px) + (py * py) <= 1) cuentaLocal++;
  }
  pthread_mutex_lock(&mut);
  *(double*)cuenta += cuentaLocal;
  pthread_mutex_unlock(&mut);
}

double piCalculation(void) {

}

int main(void) {
  double pi;
  // Seed setting
  srandom(4);
  pthread_t hilos[NHilos];
  double cuenta = 0;

  for (int i = 0; i < NHilos; i++)
    assert(!pthread_create(&hilos[i], NULL, calculo, &cuenta));
  for (int i = 0; i < NHilos; i++) assert(!pthread_join(hilos[i], NULL));
  

  pi = piCalculation();

  printf("Approximación de pi con %d puntos es: %'.10f", NPoints, pi);

  return 0;
}
