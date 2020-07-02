#include <stdio.h>

int _div(int a, int b);

int main() {
  int a = 15;
  int b = 7;

  printf("%d / %d = %d\n", a, b, _div(a, b));
}
