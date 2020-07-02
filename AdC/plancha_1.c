#include <stdio.h>

int main() {
  long a = 1;
  long b = 10;
  long c = 5;

  a = a ^ c;
  b = a ^ b;
  c = b ^ a;
  b = b ^ c;
  printf("%d %d %d\n", a, b, c);
  return 0;
}