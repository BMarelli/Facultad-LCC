#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// ¿Qué modificaciones se tendrían que hacer al programa para que decodifique?
// Ninguna modificación, si la entrada es un mensaje condificado y se usa como
// clave la misma con la que se codificó el mensaje, se decodificará y obtendrá
// el mensaje original.

// ¿Se gana codificando más de una vez?
// No. Incluso si se codifica por dos claves distintas a y b, si se utiliza como
// clave para decodificar a xor b se puede decodificar el mensaje como si
// hubiera sido codificado una única vez.

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
