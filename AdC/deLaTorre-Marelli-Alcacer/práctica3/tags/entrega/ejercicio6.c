#include <stdio.h>

#include <stdio.h>

/*
2*x + 3*y = 8
3*x + y = 5
*/

int solve(float a, float b, float c, float d, float e, float f, float* x, float* y);

int main() {
  float x, y;
  solve(1.0, 1.0, 2.0, 1.0, 2.0, 4.0, &x, &y);

  printf("%f %f\n", x, y);

  return 0;
}
