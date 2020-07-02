#include <math.h>
#include <stdio.h>

int exponente(float x) { return (*(int*)&x & 0x7F800000) >> 23; }

int fraccion(float x) { return *(int*)&x & 0x007FFFFF; }

int myisnan(float x) { return exponente(x) == 255 && fraccion(x) != 0; }

int myisnan2(float x) { return !(x == x); }

int main() {
  float g = 0.0;
  float f = 0.0 / g;
  printf("f: %f\n", f);
  // ADVERTENCIA: 'NAN' es una extensión de GCC

  if (f == NAN) {
    printf("Es NAN\n");
  }

  if (isnan(f)) printf("isNaN dice que f es NaN\n");
  if (myisnan(f)) printf("myisNaN dice que f es NaN\n");
  if (myisnan(f)) printf("myisNaN2 dice que f es NaN\n");

  if (isnan(INFINITY)) printf("isNaN dice que inf es NaN\n");
  if (myisnan(INFINITY)) printf("myisNaN dice que inf es NaN\n");
  if (myisnan2(INFINITY)) printf("myisNaN2 dice que inf es NaN\n");

  if (isnan(INFINITY + 5.0)) printf("isNaN dice que inf + 5.0 es NaN\n");
  if (myisnan(INFINITY + 5.0)) printf("myisNaN dice que inf + 5.0 es NaN\n");
  if (myisnan2(INFINITY + 5.0)) printf("myisNaN2 dice que inf + 5.0 es NaN\n");

  if (isnan(INFINITY - INFINITY))
    printf("Pero, isNaN dice que inf - inf es NaN\n");
  if (myisnan(INFINITY - INFINITY))
    printf("Pero, myisNaN dice que inf - inf es NaN\n");
  if (myisnan2(INFINITY - INFINITY))
    printf("Pero, myisNaN2 dice que inf - inf es NaN\n");

  return 0;
}
