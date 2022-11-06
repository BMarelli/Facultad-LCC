#if !defined(__SLIST_H__)
#define __SLIST_H__

#include "../util.h"

// Un SNodo es un nodo de una lista simplemente enlazada.
typedef struct _SNodo {
  void* dato;
  struct _SNodo* sig;
} SNodo;

// Una SList es una lista simplemente enlazada.
typedef SNodo* SList;

// slist_crear: -> SList
// Devuelve una lista vacía.
SList slist_crear();

// slist_vacia: SList -> int
// Recibe una lista,
// Devuelve 1 si la lista es vacía, 0 en caso contrario.
int slist_vacia(SList slist);

// slist_agregar_inicio: SList void* -> SList
// Recibe una lista y un puntero a un dato,
// Lo agrega al inicio,
// Devuelve la lista.
SList slist_agregar_inicio(SList slist, void* dato);

// slist_eliminar_inicio: SList FDestructura -> SList
// Recibe una lista y una FDestructora,
// Elimina el primer nodo de la lista y aplica FDestructora a su dato.
SList slist_eliminar_inicio(SList slist, FDestructora destruir_dato);

// slist_destruir: SList FDestructora -> void
// Recibe una lista y una FDestructora,
// La destruye y aplica la FDestructora al dato de cada nodo.
void slist_destruir(SList slist, FDestructora destruir_dato);

// slist_recorrer: SList FVisitante -> void
// Recibe una lista y una FVisitante,
// Aplica la FVisitante a los datos de la lista.
void slist_recorrer(SList slist, FVisitante visitar);

// slist_recorrer_extra: SList FVisitanteExtra void* -> void
// Recibe una lista, una FVisitanteExtra y un puntero a un dato extra,
// Aplica la FVisitanteExtra a los datos de la lista, con el argumento extra.
void slist_recorrer_extra(SList slist, FVisitanteExtra visitar, void* extra);

// slist_longitud: SList -> int
// Recibe una lista,
// Devuelve su longitud.
int slist_longitud(SList slist);

#endif  // __SLIST_H__
