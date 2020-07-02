#include "slist.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

SList slist_crear() { return NULL; }

int slist_vacia(SList slist) { return slist == NULL; }

SList slist_agregar_inicio(SList slist, void* dato) {
  SNodo* nuevoNodo = malloc(sizeof(struct _SNodo));
  nuevoNodo->dato = dato;
  nuevoNodo->sig = slist;

  return nuevoNodo;
}

SList slist_agregar_final(SList slist, void* dato) {
  SNodo* nuevoNodo = malloc(sizeof(struct _SNodo));
  nuevoNodo->dato = dato;
  nuevoNodo->sig = NULL;

  if (slist_vacia(slist)) return nuevoNodo;
  SNodo* nodo = slist;

  for (; nodo->sig != NULL; nodo = nodo->sig);
  nodo->sig = nuevoNodo;

  return slist;
}

void slist_imprimir(SList slist) {
  if (!slist_vacia(slist)) {
    for (SNodo* nodo = slist; nodo != NULL; nodo = nodo->sig) {
      printf("%s\n", (char*)nodo->dato);
    }
  }
}

void slist_destruir(SList slist) {
  if (!slist_vacia(slist)) {
    SNodo* nodoEliminar;
    while (slist != NULL) {
      nodoEliminar = slist;
      slist = slist->sig;
      free(nodoEliminar->dato);
      free(nodoEliminar);
    }
  }
}

int slist_longitud(SList slist) {
  int longitud = 0;
  for (SNodo* nodo = slist; nodo != NULL; nodo = nodo->sig) longitud++;

  return longitud;
}


int ciudad_a_indice(SList slist, char* ciudad) {
  SNodo *nodo = slist;
  int i = 0;

  for (; nodo != NULL && strcmp(ciudad, nodo->dato); i++, nodo = nodo->sig);

  return i;
}

char* indice_a_ciudad(SList lista, int i) {
  int indice = 0;
  SNodo* nodo = lista;

  for (; nodo != NULL && indice != i; indice++, nodo = nodo->sig);

  return nodo->dato;
}