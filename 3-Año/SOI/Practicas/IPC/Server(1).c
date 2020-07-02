#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/un.h> /* Unix Connection*/
#include <unistd.h>

#include "Conf.h"

#define LISTEN_MAX 5

int main(void) {
  int sock, soclient;
  char buf[1024];
  struct sockaddr_un midir, clidir;
  socklen_t clilen;

  /* Socket Init */
  if ((sock = socket(AF_UNIX, SOCK_STREAM, 0)) < 0) {
    perror("Socket init");
    exit(1);
  }

  /* Address setting */
  midir.sun_family = AF_UNIX;
  strcpy(midir.sun_path, Direccion);

  /* Trying to bind*/
  if (bind(sock, (struct sockaddr *)&midir, sizeof(struct sockaddr_un)) == -1) {
    perror("Trying to bind");
    exit(1);
  }

  printf("Binding successful, and listening\n");
  /*Now we can listen for connections*/
  if (listen(sock, LISTEN_MAX) == -1) {
    perror(" Listen error ");
    exit(1);
  }

  /* Now we can accept connections as they come*/
  clilen = sizeof(struct sockaddr_un);
  if ((soclient = accept(sock, (struct sockaddr *)&clidir, &clilen)) == -1) {
    perror("Accepting error");
    exit(1);
  }
  /*Connection Successful*/
  printf("Connected!\n");
  /* SEND PING! */
  send(soclient, "PING!", sizeof("PING!"), 0);
  /* WAIT FOR PONG! */
  recv(soclient, buf, sizeof(buf), 0);
  printf("Recv: %s\n", buf);

  close(sock);
  remove(Direccion);

  return 0;
}
