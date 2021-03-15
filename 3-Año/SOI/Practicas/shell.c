#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

#define MAX 300

int main() {
  char comando[MAX];
  while (1) {
    printf("> ");
    fgets(comando, MAX, stdin);
    int largo = strlen(comando);
    if (!fork()) {
      printf("Ejecutando %s", comando);
      sleep(3);
      printf("Fin\n");
      break;
    } else {
      if (comando[largo - 2] != '&') wait(NULL);
    }
  }
  return 0;
}
