#include <stdio.h>

unsigned long fact1(unsigned long);
unsigned long fact2(unsigned long);

int main() {
  printf("1:%lu\n", fact1(5));
  printf("2:%lu\n", fact2(5));
  return 0;
}
