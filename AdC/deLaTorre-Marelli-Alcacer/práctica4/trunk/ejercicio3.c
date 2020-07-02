#include <stdio.h>

unsigned char rgb_to_gray1(unsigned rgb);
unsigned char rgb_to_gray2(unsigned rgb);
unsigned char ycbcr_to_gray(unsigned rgb);

int main() {
  printf("rgb_to_gray1(0xffea33): %d\n", rgb_to_gray1(0xffea33));
  printf("rgb_to_gray2(0xffea33): %d\n", rgb_to_gray2(0xffea33));
  printf("ycbcr_to_gray(0xffea33): %d\n", ycbcr_to_gray(0xffea33));
  return 0;
}
