#include <stdio.h>
#include <string.h>

#define FINALPATH ".final"
int main(int argc, char const *argv[])
{
  if (argc == 3) {
    printf("%s\n", argv[2]);
  } else {
    char output[strlen(argv[1]) + 2];
    strcpy(output, strtok((char*)argv[1], "."));
    strcat(output, FINALPATH);
    printf("%s\n", output);
  }
}

