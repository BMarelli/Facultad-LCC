#include <stdio.h>

unsigned long fact1(unsigned long);
unsigned long fact2(unsigned long);

int main(void) {
  unsigned long x;

  printf("x: ");
  scanf("%lu", &x);
  printf("fact1(x): %lu\n", fact1(x));
  printf("fact2(x): %lu\n", fact2(x));

  return 0;
}
