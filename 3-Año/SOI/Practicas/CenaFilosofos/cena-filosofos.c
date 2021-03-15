#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define N_FILOSOFOS 5
#define ESPERA 5000000

pthread_mutex_t tenedor[N_FILOSOFOS];

void pensar(int i) {
  printf("Filosofo %d pensando...\n", i);
  usleep(random() % ESPERA);
}

void comer(int i) {
  printf("Filosofo %d comiendo...\n", i);
  usleep(random() % ESPERA);
}

void tomar_tenedores(int i) {
  if (i == 0) {
    pthread_mutex_lock(&tenedor[(i + 1) % N_FILOSOFOS]);
    pthread_mutex_lock(&tenedor[i]);
  } else {
    pthread_mutex_lock(&tenedor[i]);
    pthread_mutex_lock(&tenedor[(i + 1) % N_FILOSOFOS]);
  }
}

void dejar_tenedores(int i) {
  pthread_mutex_unlock(&tenedor[i]);
  pthread_mutex_unlock(&tenedor[(i + 1) % N_FILOSOFOS]);
}

void *filosofo(void *arg) {
  int i = *(int *)arg;
  for (;;) {
    tomar_tenedores(i);
    comer(i);
    dejar_tenedores(i);
    pensar(i);
  }
}

int main() {
  int i;
  pthread_t filo[N_FILOSOFOS];
  for (i = 0; i < N_FILOSOFOS; i++) pthread_mutex_init(&tenedor[i], NULL);
  for (i = 0; i < N_FILOSOFOS; i++)
    pthread_create(&filo[i], NULL, filosofo, &i);
  pthread_join(filo[0], NULL);
  return 0; 
}
