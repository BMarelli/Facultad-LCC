#include "util.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TAMANO_BUFFER_INICIAL 32

int es_simbolo(char c) {
  return ((0 <= c && c <= 31) || (33 <= c && c <= 64) || (91 <= c && c <= 96) ||
          (123 <= c && c <= 127) || (155 <= c && c <= 159) ||
          (166 <= c && c <= 255));
}

char *get_line(FILE *archivo, int permitirSimbolos) {
  int tamano = TAMANO_BUFFER_INICIAL;

  char c = fgetc(archivo);

  // prevenimos que dos saltos de linea seguidos creen una cadena vacia.
  while ((c == '\n' || c == '\r') && c != EOF) c = fgetc(archivo);

  if (c == EOF) return NULL;

  char *buffer = malloc(sizeof(char) * (tamano + 1));

  int i = 0;
  while ((c != '\n' && c != '\r' && c != EOF)) {
    if (i == tamano) {
      tamano *= 2;
      buffer = realloc(buffer, sizeof(char) * (tamano + 1));
    }

    if (permitirSimbolos || !es_simbolo(c)) {
      buffer[i++] = c;
    }

    c = fgetc(archivo);
  }
  buffer[i] = '\0';

  buffer = realloc(buffer, sizeof(char) * (strlen(buffer) + 1));

  return buffer;
}

void imprimir_persona(void *dato) {
  Persona *persona = dato;
  printf("%s, %d, %s\n", persona->nombre, persona->edad,
         persona->lugarDeNacimiento);
}

void imprimir_cadena(void *dato) { printf("%s\n", (char *)dato); }

void escribir_persona(void *dato, FILE *archivo) {
  Persona *persona = dato;
  fprintf(archivo, "%s, %d, %s\n", persona->nombre, persona->edad,
          persona->lugarDeNacimiento);
}

void escribir_cadena(void *dato, FILE *archivo) {
  fprintf(archivo, "%s\n", (char *)dato);
}

void destruir_cadena(void *dato) { free(dato); }

void destruir_persona(void *dato) {
  Persona *persona = dato;
  free(persona->nombre);
  free(persona->lugarDeNacimiento);
  free(persona);
}

void *copiar_persona(void *dato) {
  Persona *persona = dato;
  Persona *nueva = malloc(sizeof(Persona));
  nueva->nombre = malloc(sizeof(char) * (strlen(persona->nombre) + 1));
  strcpy(nueva->nombre, persona->nombre);
  nueva->edad = persona->edad;
  nueva->lugarDeNacimiento =
      malloc(sizeof(char) * (strlen(persona->lugarDeNacimiento) + 1));
  strcpy(nueva->lugarDeNacimiento, persona->lugarDeNacimiento);

  return nueva;
}

void *copiar_cadena(void *dato) {
  char *nuevaCadena = malloc(sizeof(char) * (strlen(dato) + 1));
  strcpy(nuevaCadena, dato);
  return nuevaCadena;
}
