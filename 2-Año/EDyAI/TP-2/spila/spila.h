#if !defined(__SPILA_H__)
#define __SPILA_H__

#include "../util.h"
#include "../slist/slist.h"

// Una SPila es una pila implementada utilizando SList.
typedef SList SPila;

// spila_pila: -> SPila
// Crea e inicializa una pila vacía,
// Devuelve la pila.
SPila spila_crear();

// spila_vacia: SPila -> int
// Recibe una pila,
// Devuelve 1 si la pila esta vacía, 0 en el caso contrario.
int spila_vacia(SPila spila);

// spila_top: SPila -> void*
// Recibe una pila,
// Devuelve el dato superior de la pila.
void* spila_top(SPila spila);

// spila_push: SPila void* -> SPila
// Recibe una pila y un puntero a un dato,
// añade el dato a la pila,
// Devuelve la pila.
SPila spila_push(SPila spila, void* dato);

// spila_pop: SPila FDestructora -> SPila
// Recibe una pila y un FDestructora,
// Elimina el elemento superior de la pila y aplica la FDestructora a su dato,
// Devuelve la pila.
SPila spila_pop(SPila spila, FDestructora destruir_dato);

// spila_destruir: SPila FDestructora -> void
// Recibe una pila y un FDestructora,
// Destruye la pila y aplica la FDestructora a todos los datos.
void spila_destruir(SPila spila, FDestructora destruir_dato);

// spila_recorrer: SPila FVisitante -> void
// Recibe una pila y una FVisitante,
// Aplica la FVisitante a los elementos de la pila.
void spila_recorrer(SPila spila, FVisitante visitar);

// spila_recorrer_extra: SPila FVisitante void* -> void
// Recibe una pila, una FVisitanteExtra y un puntero a un dato extra,
// Aplica la FVisitanteExtra a los datos de la pila, con el argumento extra.
void spila_recorrer_extra(SPila spila, FVisitanteExtra visitar, void* extra);

#endif  // __SPILA_H_
