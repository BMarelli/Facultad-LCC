#include "trie.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../spila/spila.h"

TNodo* tnodo_crear() {
  TNodo* tnodo = malloc(sizeof(TNodo));
  tnodo->padre = NULL;
  tnodo->identificador = -1;
  tnodo->termina = 0;
  tnodo->maxProfundidad = 0;

  for (int i = 0; i < TAMANO_ALFABETO; i++) tnodo->hijos[i] = NULL;

  return tnodo;
}

void tnodo_destruir(TNodo* tnodo) {
  if (tnodo == NULL) return;

  for (int i = 0; i < TAMANO_ALFABETO; i++) tnodo_destruir(tnodo->hijos[i]);
  free(tnodo);
}

int tnodo_buscar(TNodo* tnodo, char* palabra, int i) {
  int longitud = strlen(palabra);
  if (tnodo == NULL || tnodo->maxProfundidad < longitud - i) return 0;

  for (int j = i; j < longitud && tnodo != NULL; j++) {
    int indice = caracter_a_indice(palabra[j], 1);
    if (indice != -1) tnodo = tnodo->hijos[indice];
  }

  return tnodo != NULL && tnodo->termina;
}

Trie* trie_crear() {
  Trie* trie = malloc(sizeof(TNodo));
  trie->origen = tnodo_crear();

  return trie;
}

void trie_agregar(Trie* trie, char* palabra) {
  int longitud = strlen(palabra);

  TNodo* nodo = trie->origen;
  for (int i = 0; i < longitud; i++) {
    int indice = caracter_a_indice(palabra[i], 1);
    if (indice != -1) {
      if (nodo->hijos[indice] == NULL) {
        nodo->hijos[indice] = tnodo_crear();
        nodo->hijos[indice]->padre = nodo;
        nodo->hijos[indice]->identificador = indice;
      }

      nodo->maxProfundidad = max(nodo->maxProfundidad, longitud - i);
      nodo = nodo->hijos[indice];
    }
  }

  if (nodo != trie->origen) nodo->termina = 1;
}

int trie_contiene(Trie* trie, char* palabra) {
  return tnodo_buscar(trie->origen, palabra, 0);
}

Sugerencias* trie_sugerir(Trie* trie, char* palabra, int cantidadSugerencias) {
  Sugerencias* sugerencias = sugerencias_crear(cantidadSugerencias);

  int N = 0;
  while (!sugerencias_lleno(sugerencias)) {
    N++;
    _transformar(palabra, trie->origen, spila_crear(), 0, trie->origen,
                 sugerencias, N);
  }

  return sugerencias;
}

void trie_destruir(Trie* trie) {
  tnodo_destruir(trie->origen);
  free(trie);
}

void _transformar(char* palabra, TNodo* nodo, SPila anteriores, int i,
                  TNodo* origen, Sugerencias* sugerencias, int N) {
  if (nodo == NULL || N == 0) return;

  _agregar_letras(palabra, nodo, anteriores, i, origen, sugerencias, N);
  _eliminar_letras(palabra, nodo, anteriores, i, origen, sugerencias, N);
  _intercambiar_letras(palabra, nodo, anteriores, i, origen, sugerencias, N);
  _transponer_letras(palabra, nodo, anteriores, i, origen, sugerencias, N);
  _separar_palabras(palabra, nodo, anteriores, i, origen, sugerencias, N);
}

void _apilar_padres(TNodo* tnodo, SPila* caracteres) {
  TNodo* nodoActual = tnodo;
  while (nodoActual->padre != NULL) {
    int indice = nodoActual->identificador;
    Caracter* caracter = caracter_crear(indice_a_caracter(indice));
    *caracteres = spila_push(*caracteres, caracter);
    if (indice >= 26) {
      Caracter* especial = caracter_crear(-61);
      *caracteres = spila_push(*caracteres, especial);
    }
    nodoActual = nodoActual->padre;
  }
}

void _reconstruir_anterior(void* dato, void* extra) {
  SPila* caracteres = extra;
  Caracter* espacio = caracter_crear(' ');
  *caracteres = spila_push(*caracteres, espacio);
  _apilar_padres((TNodo*)dato, caracteres);
}

char* _reconstruir(SPila anteriores, TNodo* nodoActual, char* palabra, int i) {
  SPila caracteres = spila_crear();
  _apilar_padres(nodoActual, &caracteres);

  spila_recorrer_extra(anteriores, _reconstruir_anterior, &caracteres);

  int prefijo = slist_longitud(caracteres), sufijo = strlen(palabra) - i;
  char* sugerencia = malloc(sizeof(char) * (prefijo + sufijo + 1));

  for (int c = 0; !spila_vacia(caracteres); c++) {
    sugerencia[c] = ((Caracter*)spila_top(caracteres))->caracter;
    caracteres = spila_pop(caracteres, destruir_generico);
  }

  for (int c = 0; c < sufijo; c++) sugerencia[prefijo + c] = palabra[i + c];

  sugerencia[prefijo + sufijo] = '\0';

  return sugerencia;
}

void _agregar_letras(char* palabra, TNodo* nodo, SPila anteriores, int i,
                     TNodo* origen, Sugerencias* sugerencias, int N) {
  int longitud = strlen(palabra);

  if (nodo->maxProfundidad < longitud - i) return;
  int j = 0;
  while (j <= longitud - i && nodo != NULL && !sugerencias_lleno(sugerencias)) {
    int indice = caracter_a_indice(palabra[j + i], 1);

    int c = 0;
    while (c < TAMANO_ALFABETO && (indice != -1 || j == longitud - i)) {
      if (c != indice) {
        if (tnodo_buscar(nodo->hijos[c], palabra, i + j)) {
          char* sugerencia =
              _reconstruir(anteriores, nodo->hijos[c], palabra, j + i);

          if (!sugerencias_anadir(sugerencias, sugerencia)) free(sugerencia);
        }

        _transformar(palabra, nodo->hijos[c], anteriores, i + j, origen,
                     sugerencias, N - 1);
      }
      c++;
    }

    if (indice != -1) nodo = nodo->hijos[indice];
    j++;
  }
}

void _eliminar_letras(char* palabra, TNodo* nodo, SPila anteriores, int i,
                      TNodo* origen, Sugerencias* sugerencias, int N) {
  int longitud = strlen(palabra);

  int j = 0;
  while (j < longitud - i && nodo != NULL && !sugerencias_lleno(sugerencias)) {
    int indice = caracter_a_indice(palabra[i + j], 1);
    int indiceSig = caracter_a_indice(palabra[i + j + 1], 1);

    int intentar = indice != indiceSig || nodo->hijos[indiceSig] == NULL;
    if (indice != -1 && intentar) {
      if (tnodo_buscar(nodo, palabra, i + j + 1)) {
        char* sugerencia = _reconstruir(anteriores, nodo, palabra, j + i + 1);
        if (!sugerencias_anadir(sugerencias, sugerencia)) free(sugerencia);
      }

      _transformar(palabra, nodo, anteriores, i + j + 1, origen, sugerencias,
                   N - 1);
    }

    if (indice != -1) nodo = nodo->hijos[indice];
    j++;
  }
}

void _intercambiar_letras(char* palabra, TNodo* nodo, SPila anteriores, int i,
                          TNodo* origen, Sugerencias* sugerencias, int N) {
  int longitud = strlen(palabra);

  int j = 0;
  while (j < longitud - i && nodo != NULL && !sugerencias_lleno(sugerencias)) {
    int indice = caracter_a_indice(palabra[j + i], 1);

    int c = 0;
    while (c < TAMANO_ALFABETO && indice != -1) {
      if (c != indice) {
        if (tnodo_buscar(nodo->hijos[c], palabra, i + j + 1)) {
          char* sugerencia =
              _reconstruir(anteriores, nodo->hijos[c], palabra, j + i + 1);

          if (!sugerencias_anadir(sugerencias, sugerencia)) free(sugerencia);
        }

        _transformar(palabra, nodo->hijos[c], anteriores, i + j + 1, origen,
                     sugerencias, N - 1);
      }

      c++;
    }

    if (indice != -1) nodo = nodo->hijos[indice];
    j++;
  }
}

void _transponer_letras(char* palabra, TNodo* nodo, SPila anteriores, int i,
                        TNodo* origen, Sugerencias* sugerencias, int N) {
  int longitud = strlen(palabra);

  for (int j = 0; j < longitud - i - 1 && !sugerencias_lleno(sugerencias); j++) {
    transponer_adyacentes(palabra, i + j);

    if (tnodo_buscar(nodo, palabra, i)) {
      char* sugerencia = _reconstruir(anteriores, nodo, palabra, i);
      if (!sugerencias_anadir(sugerencias, sugerencia)) free(sugerencia);
    }

    _transformar(palabra, nodo, anteriores, i, origen, sugerencias, N - 1);

    transponer_adyacentes(palabra, i + j);

    if (caracter_a_indice(palabra[i + j], 1) == -1) j++;
  }
}

void _separar_palabras(char* palabra, TNodo* nodo, SPila anteriores, int i,
                       TNodo* origen, Sugerencias* sugerencias, int N) {
  int longitud = strlen(palabra);

  int j = 0;
  while (j < longitud - i && nodo != NULL && !sugerencias_lleno(sugerencias)) {
    int indice = caracter_a_indice(palabra[i + j], 1);
    TNodo* hijo = nodo->hijos[indice];

    if (indice != -1 && hijo != NULL && hijo->termina) {
      SPila _anteriores = spila_push(anteriores, hijo);

      if (tnodo_buscar(origen, palabra, i + j + 1)) {
        char* sugerencia =
            _reconstruir(_anteriores, origen, palabra, i + j + 1);
        if (!sugerencias_anadir(sugerencias, sugerencia)) free(sugerencia);
      }

      _transformar(palabra, origen, _anteriores, i + j + 1, origen, sugerencias,
                   N - 1);
      free(_anteriores);
    }

    if (indice != -1) nodo = nodo->hijos[indice];

    j++;
  }
}
