#include <stdio.h>
#include <string.h>

unsigned long buscar_caracter(char* cadena, char caracter, unsigned long longitud);
unsigned long comparar_cadenas(char* cadena1, char* cadena2, unsigned long longitud);
unsigned long fuerza_bruta(char* cadena1, char* cadena2, unsigned long longitud1, unsigned long longitud2);

int main() {
  char cadena1[] = "yea yea dice el DANI";
  char cadena2[] = "tupercalifrajilisticoespialidoso";
  char cadena3[] = "yea dice";
  char caracter = 'y';

  printf("a): %ld\n", buscar_caracter(cadena1, caracter, strlen(cadena1)));
  printf("b): %ld\n", comparar_cadenas(cadena1, cadena2, strlen(cadena1)));
  printf("c): %ld\n", fuerza_bruta(cadena1, cadena3, strlen(cadena1), strlen(cadena3)));

  return 0;
}
