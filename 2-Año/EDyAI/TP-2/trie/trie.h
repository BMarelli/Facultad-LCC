#if !defined(_TRIE_H_)
#define _TRIE_H_

#include "../slist/slist.h"
#include "../spila/spila.h"
#include "../util.h"

// Representamos nuestro diccionario mediante un Trie. Un Trie cuenta con un
// origen, representado por un puntero a un TNodo.
// Un TNodo es un nodo de un Trie. Cada TNodo tiene un padre, un arreglo de
// TAMANO_ALFABETO hijos (*), un identificador, un flag que indica si una
// palabra finaliza en este nodo, y la maxima profundidad desde ese nodo (**).
// La representación funciona de la siguiente manera:
// - Supongamos que nuestro universo de palabras válidas es "perro", "gato",
//   "perros", "pera".
// - Nuestro Trie va a tener un origen vacío, es decir con padre == NULL,
//   identificador == -1, termina == 0 y maxProfundidad == 6. El arreglo de
//   hijos va a constar mayoritariamente de punteros NULL, pero en los índices
//   correspondientes a 'p' y 'g' va a contener punteros a dos TNodo distintos.
// - Este hijo 'p' tendrá padre == origen, identificador == 15 (p <-> 15,
//   referir a util.h), termina == 0, maxProfundidad == 5 y un único hijo no
//   nulo correspondiente a una 'e'.
// - Similarmente, el hijo 'g' tendrá padre == origen, identificador == 6
//   (g <-> 6, referir a util.h), termina == 0, maxProfundidad == 3 y un único
//   hijo no nulo correspondiente a una 'a'.
// - La idea es representar todas las palabras del universo letra por letra
//   siguiendo una relación de descendencia. Visualmente, indicando nodos en los
//   cuales termina una palabra con '!', tendríamos:
//
//         ┌> 'g' --> 'a' --> 't' --> 'o'!
//  origen ┤
//         │
//         │                      ┌> 'r' --> 'o'! --> 's'!
//         └> 'p' --> 'e' --> 'r' ┤
//                                └> 'a'!
// Notas:
// (*): Utilizar esta representación implica un uso de memoria innecesario, en
//      el sentido que estamos reservando espacio que en general termina siendo
//      inutilizado al tener mayoritariamente punteros NULL. Utilizando una
//      solución alternativa (con SList en lugar de un arreglo), notamos una
//      gran reducción de la memoría utilizada pero asimismo un aumento del
//      tiempo de ejecución del programa. Por esta razón, decidimos utilizar
//      esta implementación como versión final.
// (**): La máxima profundidad desde un nodo es calculada utilizando strlen,
//       es decir que tiene en cuenta 2 caracteres cuando hay un
//       caracter especial. Por ejemplo, ñoño tiene longitud 6 ya que cada ñ
//       cuenta como 2 caracteres.

typedef struct _TNodo {
  struct _TNodo* padre;
  struct _TNodo* hijos[TAMANO_ALFABETO];
  int identificador;
  int termina;
  int maxProfundidad;
} TNodo;

typedef struct {
  TNodo* origen;
} Trie;

// tnodo_crear: -> TNodo*
// Crea un TNodo con padre == NULL, identificador == -1 y termina == 0,
// Devuelve un puntero al mismo.
TNodo* tnodo_crear();

// tnodo_destruir: TNodo* -> void
// Recibe un puntero a un TNodo,
// Destruye el mismo y a todos sus hijos.
void tnodo_destruir(TNodo* tnodo);

// tnodo_buscar: TNodo* char* int -> int
// Recibe un puntero a un TNodo, una palabra y un índice,
// Devuelve 1 si logra encontrar la palabra comenzando desde el caracter i-ésimo
// a partir del nodo indicado, 0 en caso contrario.
int tnodo_buscar(TNodo* tnodo, char* palabra, int i);

// trie_crear: -> Trie*
// Crea e inicializa un Trie,
// Devuelve un puntero al mismo.
Trie* trie_crear();

// trie_agregar: Trie char* -> void
// Recibe un puntero a un Trie y una palabra,
// Agrega la palabra al Trie.
void trie_agregar(Trie* trie, char* palabra);

// trie_contiene: Trie char* -> int
// Recibe un puntero a un Trie y una palabra,
// Devuelve 1 si el Trie contiene la cadena, 0 en caso contrario.
int trie_contiene(Trie* trie, char* palabra);

// trie_destruir: Trie* -> void
// Recibe un puntero a un Trie,
// Lo destruye.
void trie_destruir(Trie* trie);

// _apilar_padres: TNodo* SPila* -> void
// Recibe un puntero a un TNodo y un puntero a una SPila de Caracter(es),
// Agrega a la pila el caracter correspondiente al nodo, el correspondiente al
// padre del nodo, el correspondiente al padre del padre del nodo, ..., hasta
// llegar al origen.
void _apilar_padres(TNodo* tnodo, SPila* caracteres);

// _reconstruir_anterior: void* void* -> void
// Recibe un puntero a un dato (TNodo) y un puntero a un dato extra (SPila),
// Apila un caracter ' ' a la SPila, y luego llama _apilar_padres sobre el
// TNodo* recibido.
// Esta función es de tipo FVisitanteExtra.
void _reconstruir_anterior(void* dato, void* extra);

// _reconstruir: SPila TNodo* char* int -> char*
// Recibe una SPila de TNodo* (anteriores), un puntero a un TNodo (nodoActual),
// una palabra y un índice,
// Construye y devuelve una cadena de la siguiente manera:
// - En cada TNodo* de la pila "anteriores" termina una palabra, por lo que
//   reconstruimos dichas palabras y las encadenamos con espacios -> anterior_i
// - Agregamos a esta cadena la cadena formada al recorrer nodoActual hasta el
//   origen -> prefijo
// - Agregamos a lo anterior la subcadena de palabra desde el caracter i-ésimo
// -> sufijo
// Es decir, la palabra resultante es de la forma:
//   [anterior_n] [anterior_n-1] ... [anterior_1] [prefijo][sufijo]
char* _reconstruir(SPila anteriores, TNodo* nodoActual, char* palabra, int i);

// trie_sugerir: Trie* char* int -> Sugerencias*
// Recibe un puntero a un Trie, una palabra y la cantidad de sugerencias a
// generar,
// Busca sugerencias para la palabra mediante combinaciones de las siguientes
// técnicas:
// - Agregar una letra
// - Eliminar una letra
// - Cambiar una letra
// - Intercambiar caracteres adyacentes
// - Agregar espacios
// Prioriza como sugerencias aquellas que son conseguidas utilizando la menor
// cantidad de alteraciones posibles.
// Devuelve un puntero a una estructura Sugerencias con cantidadSugerencias
// sugerencias.
Sugerencias* trie_sugerir(Trie* trie, char* palabra, int cantidadSugerencias);

// _transformar: char* TNodo* SPila int TNodo* Sugerencias* int -> void
// Recibe una cadena, un nodo, una pila de anteriores, un índice (i), el origen
// del trie, un puntero a una estructura Sugerencias y la cantidad de niveles de
// profundidad restantes,
// Llama las siguientes funciones, para generar las sugerencias en el nivel de
// profundidad actual:
// - _agregar_letras
// - _eliminar_letras
// - _intercambiar_letras
// - _transponer_letras
// - _separar_palabras
// Luego esta función va a ser llamada recursivamente por todas las funciones
// anteriores.
void _transformar(char* palabra, TNodo* nodo, SPila anteriores, int i,
                  TNodo* origen, Sugerencias* sugerencias, int N);

// _agregar_letras: char* TNodo* SPila int TNodo* Sugerencias* int -> void
// Recibe una cadena, un nodo, una pila de anteriores, un indice (i), el origen
// del Trie, un puntero a una estructura Sugerencias y la cantidad de niveles
// de profundidad restantes (N),
// Prueba agregando letras desde la posición i-ésima de la palabra
// en adelante. Si encuentra una palabra valida, la agrega a la estructura
// Sugerencias.
// Luego aplica _transformar al resultado de agregar la letra, pero
// con N - 1 cantidad de niveles de profundidad restantes.
void _agregar_letras(char* palabra, TNodo* nodo, SPila anteriores, int i,
                     TNodo* origen, Sugerencias* sugerencias, int N);

// _eliminar_letras: char* TNodo* SPila int TNodo* Sugerencias* int -> void
// Recibe una cadena, un nodo, una pila de anteriores, un indice (i), el origen
// del Trie, un puntero a una estructura Sugerencias y la cantidad de niveles
// de profundidad restantes (N),
// Prueba eliminando letras desde la posicion i-esima de la cadena en adelante.
// Si encuentra una palabra valida, la agrega a la estructura Sugerencias.
// Luego aplica _transformar al resultado de eliminar la letra, pero con N - 1
// cantidad de niveles de profundidad restantes.
void _eliminar_letras(char* palabra, TNodo* nodo, SPila anteriores, int i,
                      TNodo* origen, Sugerencias* sugerencias, int N);

// _intercambiar_letras: char* TNodo* SPila int TNodo* Sugerencias* int -> void
// Recibe una cadena, un nodo, una pila de anteriores, un indice (i), el origen
// del trie, un puntero a una estructura Sugerencias y la cantidad de niveles
// de profundidad restantes (N),
// Prueba intercambiando letras desde la posicion i-esima de la cadena en
// adelante.
// Si encuentra una palabra valida, la agrega a la estructura Sugerencias.
// Luego aplica _transformar al resultado de intercambiar la letra, pero con
// N - 1 cantidad de niveles de profundidad restantes.
void _intercambiar_letras(char* palabra, TNodo* nodo, SPila anteriores, int i,
                          TNodo* origen, Sugerencias* sugerencias, int N);

// _transponer_letras: char* TNodo* SPila int TNodo* Sugerencias* int -> void
// Recibe una cadena, un nodo, una pila de anteriores, un indice (i), el origen
// del trie, un puntero a una estructura Sugerencias y la cantidad de niveles
// de profundidad restantes (N),
// Prueba trasponiendo letras adyacentes desde la posicion i-esima de la cadena
// en adelante.
// Si encuentra una palabra valida, la agrega a la estructura Sugerencias.
// Luego aplica _transformar al resultado de transponer las letras, pero con N -
// 1 cantidad de niveles de profundidad restantes.
void _transponer_letras(char* palabra, TNodo* nodo, SPila anteriores, int i,
                        TNodo* origen, Sugerencias* sugerencias, int N);

// _separar_palabras: char* TNodo* SPila int TNodo* Sugerencias* int -> void
// Recibe una cadena, un nodo, una pila de anteriores, un indice (i), el origen
// del trie, un puntero a una estructura Sugerencias y la cantidad de niveles
// de profundidad restantes (N),
// Prueba si insertando espacios entre las letras desde la posición i-ésima
// resulta en obtener 1 palabra válida seguida de otra (que puede no serlo).
// Si ambas son válidas, las agrega a la estructura Sugerencias como "[palabra1]
// [palabra2]". Cada vez que haya una palabra insertando espacios, agrega el
// último nodo a la pila de anteriores y llama _transformar desde el nodo
// origen, con esta nueva pila de anteriores, la subcadena restante y con N - 1
// niveles de profundidad restantes.
void _separar_palabras(char* palabra, TNodo* nodo, SPila anteriores, int i,
                       TNodo* origen, Sugerencias* sugerencias, int N);

#endif  // _TRIE_H_
