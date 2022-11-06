#include <netinet/in.h>
#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

#define MAX_CLIENTS 1
int sock, *soclient;
pthread_t chanels[2];

void error(char *msg);

void signalManager(int sig) {
  shutdown(*soclient, 2);
  close(sock);
  close(*soclient);
}

void *recive_mess(void *sock);
void *send_mess(void *sock);

int main(int argc, char **argv) {
  signal(SIGINT, signalManager);
  struct sockaddr_in servidor, clientedir;
  socklen_t clientelen;
  pthread_attr_t attr;

  if (argc <= 1) error("Faltan argumentos");

  if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0) error("Socket Init");

  servidor.sin_family = AF_INET;
  servidor.sin_addr.s_addr = INADDR_ANY;
  servidor.sin_port = htons(atoi(argv[1]));

  if (bind(sock, (struct sockaddr *)&servidor, sizeof(servidor)))
    error("Error en el bind");

  printf("Binding successful, and listening on %s\n", argv[1]);

  pthread_attr_init(&attr);
  pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);

  if (listen(sock, MAX_CLIENTS) == -1) error(" Listen error ");

  soclient = malloc(sizeof(int));

  clientelen = sizeof(clientedir);
  if ((*soclient = accept(sock, (struct sockaddr *)&clientedir, &clientelen)) ==
      -1)
    error("No se puedo aceptar la conexión. ");

  pthread_create(&chanels[0], NULL, recive_mess, (void *)soclient);
  pthread_create(&chanels[1], NULL, send_mess, (void *)soclient);

  pthread_join(chanels[0], NULL);
  pthread_join(chanels[1], NULL);

  free(soclient);
  return 0;
}

void error(char *msg) { exit((perror(msg), 1)); }

void *recive_mess(void *sock) {
  int sock_ = *(int *)sock;
  char buf[1024];
  bzero(buf, 1024);
  while (recv(sock_, buf, sizeof(buf), 0) > 0)
    if (strlen(buf) != 1) printf("> %s", buf);
  pthread_cancel(chanels[1]);

  return NULL;
}

void *send_mess(void *sock) {
  int sock_ = *(int *)sock;
  char buf[1024];
  bzero(buf, 1024);
  while (1) {
    fgets(buf, 1024, stdin);
    if (send(sock_, buf, sizeof(buf), 0) == -1) break;
  }

  return NULL;
}
