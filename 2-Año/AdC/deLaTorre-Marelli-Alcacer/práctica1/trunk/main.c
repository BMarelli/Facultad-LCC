#include <stdio.h>
#include "nro.h"
#include "util.h"

int main(int argc, char const *argv[]) {
  // Ejercicio 1
  printf("1) a) ");
  printbin32(1 << 31);

  printf("   b) ");
  printbin32((1 << 31) | (1 << 15));

  printf("   c) ");
  printbin32(-1 & ~255);

  printf("   d) ");
  printbin32(0xAA | (0xAA << 24));

  printf("   e) ");
  printbin32(5 << 8);

  printf("   f) ");
  printbin32(-1 & (~(1 << 8)));

  // Ejercicio 2
  printf("2) 15 tiene un %d en el 5to bit de su representación binaria.\n",
         isOne(15l, 5));

  // Ejercicio 3
  printf("3) 1567 representado como un entero de 64 bits: ");
  printbin64(1567l);
  printf("   1567 representado como un entero de 32 bits: ");
  printbin32(1567);

  // Ejercicio 4
  long a = 3, b = 4, c = 12;
  printf("4) a = %ld, b = %ld, c = %ld. Luego de rotar, \n", a, b, c);
  rotar(&a, &b, &c);
  printf("   a = %ld, b = %ld, c = %ld.\n", a, b, c);

  // Ejercicio 6
  unsigned int x = 124, y = 32;
  printf("6) %d * %d = %d\n", x, y, mult(x, y));

  // Ejercicio 7
  nro num1 = nro_crear(), num2 = nro_crear();
  num1.n[0] = 912;

  num2.n[1] = 23;
  num2.n[3] = 3;

  printf("7) num1 = ");
  nro_print(num1);
  // printf("        = ");
  // nro_printbin(num1);

  printf("   num2 = ");
  nro_print(num2);
  // printf("        = ");
  // nro_printbin(num2);`

  // printf("   num1 << 52 = ");
  // nro_printbin(nro_shiftl(num1, 52));
  // printf("   num2 >> 24 = ");
  // nro_printbin(nro_shiftr(num2, 24));

  // printf("   ~num1 = ");
  // nro_printbin(nro_not(num1));
  // printf("   num1 & num2 = ");
  // nro_printbin(nro_and(num1, num2));
  // printf("   num1 | num2 = ");
  // nro_printbin(nro_or(num1, num2));
  // printf("   num1 ^ num2 = ");
  // nro_printbin(nro_xor(num1, num2));

  printf("   num1 + num2 = ");
  nro_print(nro_suma(num1, num2));
  printf("8) num1 * num2 = ");
  nro_print(nro_mult(num1, num2));
}
