#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/un.h> /* Unix Connection*/
#include <unistd.h>

#include "Conf.h"

int main(void) {
  int sock;
  char buf[1024];
  struct sockaddr_un serverdir;

  /* Socket Init */
  if ((sock = socket(AF_UNIX, SOCK_STREAM, 0)) < 0) {
    perror("Socket init");
    exit(1);
  }

  /* Address setting */
  serverdir.sun_family = AF_UNIX;
  strcpy(serverdir.sun_path, Direccion);

  /* Trying to connect! */
  if ((connect(sock, (struct sockaddr *)&serverdir,
               sizeof(struct sockaddr_un))) == -1) {
    perror("Connection failed");
    exit(1);
  }
  printf("Connection successful!\n");

  recv(sock, buf, sizeof(buf), 0);
  printf("Recv:%s\n", buf);

  send(sock, "PONG!", sizeof("PONG!"), 0);
  close(sock);

  return 0;
}
