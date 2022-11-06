#include <netdb.h>
#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

int sock;
pthread_t chanels[2];

void error(char *msg);

void signalManager(int sig) {
  shutdown(sock, SHUT_RDWR);
  close(sock);
}

void *recive_mess(void *sock);
void *send_mess(void *sock);

int main(int argc, char **argv) {
  signal(SIGINT, signalManager);
  struct addrinfo *resultado;

  if (argc != 3) {
    fprintf(stderr, "El uso es %s [IP] [port]", argv[0]);
    exit(1);
  }

  if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0)
    error("No se pudo iniciar el socket");

  if (getaddrinfo(argv[1], argv[2], NULL, &resultado)) {
    fprintf(stderr, "No se encontro el host: %s \n", argv[1]);
    exit(2);
  }

  if (connect(sock, (struct sockaddr *)resultado->ai_addr,
              resultado->ai_addrlen) != 0)

    error("No se pudo conectar :(. ");

  printf("La conexión fue un éxito!\n");

  pthread_create(&chanels[0], NULL, recive_mess, (void *)&sock);
  pthread_create(&chanels[1], NULL, send_mess, (void *)&sock);

  pthread_join(chanels[0], NULL);
  pthread_join(chanels[1], NULL);

  freeaddrinfo(resultado);

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
