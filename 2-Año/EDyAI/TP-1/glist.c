#include "glist.h"
#include <stdlib.h>
#include <string.h>
#include "util.h"

GList glist_crear() { return NULL; }

void glist_destruir(GList lista, FDestructora destruir) {
  GNodo *nodoAEliminar;
  GNodo *inicio = lista;
  do {
    nodoAEliminar = lista;
    destruir(nodoAEliminar->dato);
    lista = lista->sig;
    free(nodoAEliminar);
  } while (lista != inicio);
}

int glist_vacia(GList lista) { return lista == NULL; }

GList glist_agregar_inicio(GList lista, void *dato) {
  GNodo *nuevoNodo = malloc(sizeof(GNodo));
  nuevoNodo->dato = dato;

  if (glist_vacia(lista)) {
    nuevoNodo->sig = nuevoNodo->ant = nuevoNodo;
    return nuevoNodo;
  }

  nuevoNodo->sig = lista;
  nuevoNodo->ant = lista->ant;

  lista->ant = nuevoNodo;
  nuevoNodo->ant->sig = nuevoNodo;

  return nuevoNodo;
}

GList glist_agregar_final(GList lista, void *dato) {
  GNodo *nuevoNodo = malloc(sizeof(GNodo));
  nuevoNodo->dato = dato;

  if (glist_vacia(lista)) {
    nuevoNodo->sig = nuevoNodo->ant = nuevoNodo;
    return nuevoNodo;
  }

  nuevoNodo->sig = lista;
  nuevoNodo->ant = lista->ant;

  lista->ant = nuevoNodo;
  nuevoNodo->ant->sig = nuevoNodo;

  return lista;
}

void glist_recorrer(GList lista, FVisitante visitar) {
  GNodo *nodo = lista;
  do {
    visitar(nodo->dato);
    nodo = nodo->sig;
  } while (nodo != lista);
}

int glist_longitud(GList lista) {
  int longitud = 0;

  GNodo *nodo = lista;
  do {
    longitud++;
    nodo = nodo->sig;
  } while (nodo != lista);

  return longitud;
}

void *glist_dato_random(GList lista) {
  int tamano = glist_longitud(lista);

  int indice = rand() % tamano;
  GNodo *nodo = lista;
  if (indice < tamano / 2) {
    for (int i = 0; i < indice; i++) nodo = nodo->sig;
  } else {
    for (int i = 0; i < indice; i++) nodo = nodo->ant;
  }

  return nodo->dato;
}

GList glist_desde_archivo(char *nombre, int permitirSimbolos) {
  FILE *archivo = fopen(nombre, "r");

  if (archivo == NULL) return NULL;

  GList lista = glist_crear();

  char *linea;
  while ((linea = get_line(archivo, permitirSimbolos)) != NULL) {
    lista = glist_agregar_inicio(lista, linea);
  }

  fclose(archivo);
  return lista;
}

void glist_a_archivo(GList lista, char *nombre, FEscritora escribir) {
  FILE *archivo;
  archivo = fopen(nombre, "w+");

  GNodo *nodo = lista;
  do {
    escribir(nodo->dato, archivo);
    nodo = nodo->sig;
  } while (nodo != lista);

  fclose(archivo);
}

GList glist_map(GList lista, FMap f, FCopiadora copiar) {
  GList nuevaLista = glist_crear();

  GNodo *nodo = lista;
  do {
    void *dato = copiar(nodo->dato);
    nuevaLista = glist_agregar_final(nuevaLista, f(dato));
    nodo = nodo->sig;
  } while (nodo != lista);

  return nuevaLista;
}

GList glist_filter(GList lista, FPredicado p, FCopiadora copiar) {
  GList nuevaLista = glist_crear();

  GNodo *nodo = lista;
  do {
    if (p(nodo->dato))
      nuevaLista = glist_agregar_final(nuevaLista, copiar(nodo->dato));
    nodo = nodo->sig;
  } while (nodo != lista);

  return nuevaLista;
}
