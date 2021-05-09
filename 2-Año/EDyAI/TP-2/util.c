#include "util.h"
#include <stdlib.h>
#include <string.h>

void destruir_generico(void* dato) { free(dato); }

void no_destruir(void* dato) {}

Sugerencias* sugerencias_crear(int tamano) {
  Sugerencias* sugerencias = malloc(sizeof(Sugerencias));
  sugerencias->datos = malloc(sizeof(char*) * tamano);
  for (int i = 0; i < tamano; i++) sugerencias->datos[i] = NULL;
  sugerencias->tamano = tamano;
  sugerencias->nElems = 0;

  return sugerencias;
}

int sugerencias_anadir(Sugerencias* sugerencias, char* palabra) {
  if (sugerencias->nElems == sugerencias->tamano) return 0;
  int i = 0;
  while (i < sugerencias->nElems && strcmp(sugerencias->datos[i], palabra)) i++;
  if (i == sugerencias->nElems) {
    sugerencias->datos[i] = palabra;
    sugerencias->nElems++;
    return 1;
  } else
    return 0;
}

void sugerencias_destruir(Sugerencias* sugerencias) {
  for (int i = 0; i < sugerencias->nElems; i++) {
    free(sugerencias->datos[i]);
  }

  free(sugerencias->datos);
  free(sugerencias);
}

int sugerencias_lleno(Sugerencias* sugerencias) {
  return sugerencias->nElems == sugerencias->tamano;
}

Caracter* caracter_crear(char c) {
  Caracter* caracter = malloc(sizeof(Caracter));
  caracter->caracter = c;

  return caracter;
}

int caracter_a_indice(char caracter, int permitirCaracteresEspeciales) {
  int indice = -1;
  if ('a' <= caracter && caracter <= 'z')
    indice = caracter - 'a';
  else if ('A' <= caracter && caracter <= 'Z')
    indice = caracter - 'A';
  else if (permitirCaracteresEspeciales) {
    if (caracter <= -100) caracter -= 32;
    switch ((int)caracter) {
      case -95:
        indice = 26;  // á
        break;
      case -87:
        indice = 27;  // é
        break;
      case -83:
        indice = 28;  // í
        break;
      case -77:
        indice = 29;  // ó
        break;
      case -70:
        indice = 30;  // ú
        break;
      case -68:
        indice = 31;  // ü
        break;
      case -79:
        indice = 32;  // ñ
        break;
    }
  }
  return indice;
}

char indice_a_caracter(int indice) {
  char caracter = ' ';
  if (0 <= indice && indice <= 25)
    caracter = indice + 97;
  else {
    switch (indice) {
      case 26:
        caracter = -95;
        break;
      case 27:
        caracter = -87;
        break;
      case 28:
        caracter = -83;
        break;
      case 29:
        caracter = -77;
        break;
      case 30:
        caracter = -70;
        break;
      case 31:
        caracter = -68;
        break;
      case 32:
        caracter = -79;
        break;
    }
  }

  return caracter;
}

void swap(char* palabra, int i, int j) {
  char temp = palabra[i];
  palabra[i] = palabra[j];
  palabra[j] = temp;
}

void transponer_adyacentes(char* palabra, int i) {
  int izqEspecial = palabra[i] == -61;
  int derEspecial = palabra[i + izqEspecial + 1] == -61;

  int ambosEspeciales = izqEspecial * derEspecial;
  swap(palabra, i + ambosEspeciales, i + 1 + 2 * ambosEspeciales);

  if (izqEspecial ^ derEspecial) swap(palabra, i + derEspecial, i + 2);
}