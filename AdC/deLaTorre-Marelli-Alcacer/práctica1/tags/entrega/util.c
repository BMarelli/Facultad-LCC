#include <stdio.h>

int isOne(long n, int pos) { return (n >> pos) & 1; }

void printbin32(int n) {
  for (int i = 3; i >= 0; i--) {
    for (int j = 7; j >= 0; j--) printf("%d", isOne(n, 8 * i + j));
    printf(" ");
  }
  printf("\n");
}

void printbin64(long n) {
  for (int i = 7; i >= 0; i--) {
    for (int j = 7; j >= 0; j--) printf("%d", isOne(n, 8 * i + j));
    printf(" ");
  }
  printf("\n");
}

void rotar(long *a, long *b, long *c) {
  *a = *a ^ *c;
  *c = *a ^ *c;
  *a = *a ^ *c;
  *b = *b ^ *c;
  *c = *b ^ *c;
  *b = *b ^ *c;
}

unsigned mult(unsigned a, unsigned b) {
  if (!b) return 0;
  if (b == 1) return a;

  if (!(b & 1)) return mult(a << 1, b >> 1);
  return (a + mult(a << 1, b >> 1));
}
