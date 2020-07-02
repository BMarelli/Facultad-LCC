#define _POSIX_C_SOURCE 199309L

#include <stdio.h>
#include <sys/resource.h>
#include <sys/time.h>
#include <time.h>

void sum(float *a, float *b, int len);
void sum_simd(float *a, float *b);

int main(int argc, char const *argv[]) {
  float a[] = {1.0, 2.0, 3.1, 4.9};
  float b[] = {1.12, 2.34, 3.45, 4.56};
  float c[] = {1.19, 2.25, 3.50, 4.75};
  float d[] = {1.825, 2.3, 3.94, 4.5};

  struct timespec s, e;

  clock_gettime(CLOCK_REALTIME, &s);
  sum(a, b, 4);
  // for (int i = 0; i < 4; i++) printf("%.1f ", a[i]);
  // printf("\n");
  clock_gettime(CLOCK_REALTIME, &e);

  long secs1 = e.tv_sec - s.tv_sec;
  long ns1 = e.tv_nsec - s.tv_nsec;

  printf("Tiempo de ejecución de sum: %e s\n", secs1 + ns1 / (double)1e9);

  clock_gettime(CLOCK_REALTIME, &s);
  sum_simd(c, d);
  // for (int i = 0; i < 4; i++) printf("%.1f ", c[i]);
  // printf("\n");
  clock_gettime(CLOCK_REALTIME, &e);

  long secs2 = e.tv_sec - s.tv_sec;
  long ns2 = e.tv_nsec - s.tv_nsec;

  printf("Tiempo de ejecución de sum_simd: %e s\n", (double)secs2 + (double)ns2 / (double)1e9);

  printf("Diferencia: %e s\n", (secs1 + ns1 / (double)1e9) - (secs2 + ns2 / (double)1e9));
  // sum_simd es más rápido

  return 0;
}
