#include<pthread.h>
#include<assert.h>
#include<stdio.h>
#include<stdlib.h>

#define NVisitantes 10000
pthread_mutex_t mut = PTHREAD_MUTEX_INITIALIZER;

void * turnstile(void *argV){
  for(int j = 0; j < NVisitantes; j++)
		pthread_mutex_lock( &mut );
		(*(int *)argV) ++;
		pthread_mutex_unlock( &mut );
  return NULL;
}

int main(void){
  pthread_t ts[2];

  int *counter = malloc(sizeof(int));
  *counter = 0;

  assert(!pthread_create(&ts[0], NULL, turnstile,(void*)(counter)));
  assert(!pthread_create(&ts[1], NULL, turnstile,(void*)(counter)));

  assert(!pthread_join(ts[0], NULL));
  assert(!pthread_join(ts[1], NULL));

  printf("NVisitantes en total: %d\n", *counter);

  free(counter);
  return 0;
}
