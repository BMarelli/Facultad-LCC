#ifndef __GLIST_H__
#define __GLIST_H__

#include <stdio.h>

// COMENTARIOS:
// Implementacion de listas doblemente enlazadas circulares: Decidimos usar
// listas doblemente enlazadas por el hecho de disminuir el tiempo que se tarda
// al momento de agregar un elemento al final de la lista. Esto es ya que
// queremos mantener el orden de las lista por lo cual tenemos que utilizar
// glist_agregar_final

// Un GNodo es un nodo de una lista doblemente enlazada (circular).
typedef struct _GNodo {
  void *dato;
  struct _GNodo *ant;
  struct _GNodo *sig;
} GNodo;

// Un GList es un puntero a un GNodo.
typedef GNodo *GList;

// Una función FDestructora recibe un puntero a un dato, y lo destruye. Este
// tipo de función es pasado como argumento a glist_destruir.
typedef void (*FDestructora)(void *dato);

// Una función FVisitante recibe un puntero a un dato, y realiza alguna acción.
// Este tipo de función es pasado como argumento a glist_recorrer.
typedef void (*FVisitante)(void *dato);

// Una función FEscritora recibe un puntero a un dato y un puntero a un archivo,
// y escribe el dato al archivo de alguna manera. Este tipo de función es pasado
// como argumento a glist_a_archivo.
typedef void (*FEscritora)(void *dato, FILE *archivo);

// Una función FCopiadora recibe un puntero a un dato, y devuelve una copia del
// mismo. Este tipo de función es pasado como argumento a glist_map y a
// glist_filter.
typedef void *(*FCopiadora)(void *dato);

// Una función FMap recibe un puntero a un dato, y devuelve una alteración del
// mismo. Este tipo de función es pasado como argumento a glist_map.
typedef void *(*FMap)(void *dato);

// Una función FPredicado recibe un puntero a un dato, y devuelve 1 (verdadero)
// o 0 (falso) dependiendo de si el dato satisface o no un cierto predicado.
// Este tipo de función es pasado como argumento a glist_filter.
typedef int (*FPredicado)(void *dato);

// glist_crear: -> GList
// Devuelve una lista vacía.
GList glist_crear();

// glist_destruir: GList FDestructora -> void;
// Recibe una lista y una FDestructora,
// Ejecuta la FDestructora al dato de cada nodo y destruye todos los nodos.
void glist_destruir(GList lista, FDestructora destruir);

// glist_vacia: GList -> int;
// Recibe una lista,
// Devuelve 1 si la lista es vacía, 0 en caso contrario.
int glist_vacia(GList lista);

// glist_agregar_inicio: GList void* -> GList
// Recibe una lista y un puntero a un dato,
// Lo agrega al inicio,
// Devuelve la lista.
GList glist_agregar_inicio(GList lista, void *dato);

// glist_agregar_final: GList void* -> GList
// Recibe una lista y un puntero a un dato,
// Lo agrega al final,
// Devuelve la lista.
GList glist_agregar_final(GList lista, void *dato);

// glist_recorrer: GList FVisitante -> void
// Recibe una lista y una FVisitante,
// Recorre la lista y ejecuta la FVisitante al dato de cada nodo.
void glist_recorrer(GList lista, FVisitante visitar);

// glist_longitud: GList -> int
// Recibe una lista,
// Devuelve la longitud de la lista.
int glist_longitud(GList lista);

// glist_dato_random: GList -> void*
// Recibe una lista,
// Devuelve el dato de un nodo elegido al azar de la lista.
void *glist_dato_random(GList lista);

// glist_desde_archivo: char* int -> GList
// Recibe un nombre de archivo y un flag permitirSimbolos,
// Crea y devuelve una lista cuyos nodos contienen las lineas del archivo.
// Si permitirSimbolos es falso, excluye a todos los simbolos de la tabla ASCII.
// Si permitirSimbolos es verdadero, no excluye ningún caracter.
// Si el archivo no existe, devuelve NULL.
GList glist_desde_archivo(char *nombre, int permitirSimbolos);

// glist_a_archivo: GList char* FEscritora -> void
// Recibe una lista, un nombre de archivo y una FEscritora,
// Recorre la lista y ejecuta la FEscritora con el dato de cada nodo,
// escribiendo asi un archivo con el nombre recibido y contenido generado por la
// FEscritora.
void glist_a_archivo(GList lista, char *nombre, FEscritora escribir);

// glist_map: GList FMap FCopiadora -> GList
// Recibe una lista, una FMap y una FCopiadora
// Crea y devuelve una lista cuyos datos son los resultados de aplicar la FMap a
// una copia de cada dato (creada por la FCopiadora) de la lista recibida.
GList glist_map(GList lista, FMap f, FCopiadora copiar);

// glist_filter: GList FPredicado FCopiadora -> GList
// Recibe una lista, una FPredicado y una FCopiadora,
// Crea y devuelve una lista cuyos datos son copias (creadas por la
// FCopiadora) de los datos de la lista para los cuales la aplicación de
// FPredicado devuelve verdadero.
GList glist_filter(GList lista, FPredicado p, FCopiadora copiar);

#endif /* __GLIST_H__ */
