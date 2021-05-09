#include "spila.h"
#include <assert.h>

SPila spila_crear() { return slist_crear(); }

int spila_vacia(SPila spila) { return slist_vacia(spila); }

void* spila_top(SPila spila) {
  assert(!spila_vacia(spila));

  return spila->dato;
}

SPila spila_push(SPila spila, void* dato) {
  return slist_agregar_inicio(spila, dato);
}

SPila spila_pop(SPila spila, FDestructora destruir_dato) {
  assert(!spila_vacia(spila));

  return slist_eliminar_inicio(spila, destruir_dato);
}

void spila_destruir(SPila spila, FDestructora destruir_dato) {
  slist_destruir(spila, destruir_dato);
}

void spila_recorrer(SPila spila, FVisitante visitar) {
  slist_recorrer(spila, visitar);
}

void spila_recorrer_extra(SPila spila, FVisitanteExtra visitar, void* extra) {
  slist_recorrer_extra(spila, visitar, extra);
}
