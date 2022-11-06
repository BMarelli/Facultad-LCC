#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char const* argv[]) {
  int clave;
  if (argc == 2)
    clave = atoi(argv[1]);
  else {
    srand(time(NULL));
    clave = rand() % 256;
  }

  int i;
  while ((i = getchar()) != EOF) putchar(i ^ clave);
  printf("\n");
}
