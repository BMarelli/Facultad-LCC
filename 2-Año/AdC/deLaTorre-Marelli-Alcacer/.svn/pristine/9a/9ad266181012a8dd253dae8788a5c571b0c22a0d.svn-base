#include <stdio.h>
#include "guindows.h"

/*
  Al ejecutar el código, vemos que imprime:

    ft1: 0x7fffe62452af
    d=-1.000000
    ft2: 0x7fffe62462d3
    i=0
    ft3: 0x7fffe62472c3
    ...

  Si comparamos las direcciones de las variables dummy en ft1, ft2, ft3, esperaríamos que la distancia fuera
  aproximadamente TPILA = 4096. Entre ft2 y ft1, la diferencia es de 4132 (apenas mayor a 4096). Entre ft3 y ft2, la
  diferencia es de 4080 (?).
*/

static task t1, t2, t3, taskmain;

static void ft1(void) {
  char dummy;
  printf("ft1: %p\n", &dummy);

  for (double d = -1;; d += 0.001) {
    printf("d=%f\n", d);
    TRANSFER(t1, t2);
  }
}

static void ft2(void) {
  char dummy;
  printf("ft2: %p\n", &dummy);

  for (unsigned i = 0;; i += 2) {
    printf("i=%u\n", i);
    TRANSFER(t2, t3);
  }
}

static void ft3(void) {
  char dummy;
  printf("ft3: %p\n", &dummy);

  for (int x = 0; x < 10; x++) {
    printf("x=%d\n", x);
    TRANSFER(t3, t1);
  }

  TRANSFER(t3, taskmain);
}

int main(void) {
  stack(t1, ft1);
  stack(t2, ft2);
  stack(t3, ft3);
  TRANSFER(taskmain, t1);
  return 0;
}
