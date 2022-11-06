#if !defined(__UTIL_H__)
#define __UTIL_H__

// Una FDestructora es una función que recibe un puntero a un dato y lo
// destruye. Es usada como argumento de varias funciones que implican eliminar
// un dato, como por ejemplo:
// - slist_eliminar_inicio, slist_destruir
// - spila_pop, spila_destruir
typedef void (*FDestructora)(void*);

// no_destruir: void* -> void
// Recibe un puntero a un dato,
// No lo destruye.
// Esta función es de tipo FDestructora. Es utilizada cuando se desea realizar
// una operación de eliminación sin eliminar el dato de la memoria.
void no_destruir(void* dato);

// destruir_generico: void* -> void
// Recibe un puntero a un dato genérico,
// Lo destruye.
// Esta función es de tipo FDestructora. Es utilizada cuando free(dato) basta
// para eliminar correctamente el dato.
void destruir_generico(void* dato);

// Una FVisitante es una función que recibe un puntero a un dato y hace algo con
// él (por ejemplo, lo muestra en pantalla). Es usada como argumento a varias
// funciones en las que se recorre una estructura de datos, como por ejemplo:
// - slist_recorrer
// - spila_recorrer
typedef void (*FVisitante)(void*);

// Una FVisitanteExtra es una función que recibe un puntero a un dato y un
// puntero a un dato extra, y utiliza el primer dato para modificar el valor del
// dato extra. Es usada como argumento a varias funciones en las que se recorre
// una estructura de datos, como por ejemplo:
// - slist_recorrer_extra
// - spila_recorrer_extra
typedef void (*FVisitanteExtra)(void*, void*);

// Definimos la siguiente estructura Sugerencias para guardar las sugerencias
// generadas. No se permiten sugerencias duplicadas.
typedef struct {
  char** datos;
  int nElems;
  int tamano;
} Sugerencias;

// sugerencias_crear: int -> Sugerencias*
// Recibe un entero que representa la cantidad máxima de sugerencias a
// almacenar,
// Devuelve una puntero a nueva estructura Sugerencias con dicho tamaño.
Sugerencias* sugerencias_crear(int tamano);

// sugerencias_añadir: Sugerencias* char* -> int
// Recibe un puntero a una estructura Sugerencias y una palabra,
// Trata de añadir la palabra, si ya fue añadida previamente, devuelve 0.
// Si no, la añade y devuelve 1.
int sugerencias_anadir(Sugerencias* sugerencias, char* palabra);

// sugerencias_destruir: Sugerencias* -> void
// Recibe un puntero a una estructura Sugerencias,
// La destruye.
void sugerencias_destruir(Sugerencias* sugerencias);

// sugerencias_lleno: Sugerencias* -> int
// Recibe una estructura Sugerencias,
// Devuelve 1 si esta lleno o 0 en el caso contrario
int sugerencias_lleno(Sugerencias* sugerencias);

// Definimos la siguiente estructura Caracter para usar en una SPila de
// caracteres.
typedef struct {
  char caracter;
} Caracter;

// caracter_crear: char -> Caracter*
// Recibe un caracter,
// Crea un Caracter y devuelve un puntero al mismo.
Caracter* caracter_crear(char c);

// Representamos caracteres de la siguiente forma:
// - Consideramos iguales mayúsculas y minúsculas
// - Establecemos la siguiente biyección entre caracteres y enteros:
//   a <-> 0   b <-> 1   c <-> 2   d <-> 3   e <-> 4   f <-> 5   g <-> 6
//   h <-> 7   i <-> 8   j <-> 9   k <-> 10  l <-> 11  m <-> 12  n <-> 13
//   o <-> 14  p <-> 15  q <-> 16  r <-> 17  s <-> 18  t <-> 19  u <-> 20
//   v <-> 21  w <-> 22  x <-> 23  y <-> 24  z <-> 25  á <-> 26  é <-> 27
//   í <-> 28  ó <-> 29  ú <-> 30  ü <-> 31  ñ <-> 32
// - A cualquier otro caracter, se le asigna un -1. De esta manera filtramos
//   caracteres inválidos.
// Resulta entonces que el tamaño de nuestro alfabeto es 33, por lo que
// definimos:

#define TAMANO_ALFABETO 33

// caracter_a_indice: char int -> int
// Recibe un caracter y un flag permitirCaracteresEspeciales,
// Si permitirCaracteresEspeciales es 1, devuelve el entero que se le asigna
// según la representación de caracteres.
// Si es 0, devuelve el entero que corresponde sólo si no es un caracter
// especial.
// - Nota: por la manera en que se representan algunos caracteres especiales,
//   tenemos en cuenta que al recibirlo primero recibimos un char == -61 y luego
//   otro, pero son los dos en conjunto quienes forman el caracter especial. Por
//   ejemplo, cuando recibimos una ñ lo primero que entra es un char == -61 y
//   luego un char == -79. En esta función, ignoramos el -61 devolviendo -1 y
//   consideramos solo el siguiente valor, -79, que determina cual de los
//   caracteres especiales fue ingresado, devolviendo su representación 32.
int caracter_a_indice(char caracter, int permitirCaracteresEspeciales);

// indice_a_caracter: int -> char
// Recibe un entero,
// Devuelve el caracter que se le asigna según la representación de caracteres.
// - Nota 1: Si el entero no se encuentra en la representación, devolvemos un
//   espacio (' '). Esto es útil cuando generamos sugerencias que contienen
//   espacios.
// - Nota 2: por la manera que se representan algunos caracteres especiales,
//   devolvemos solo la porción del caracter que lo determina. Es decir, si
//   recibimos indice == 32, sabemos que buscamos una ñ. La representación real
//   de este caracter esta compuesta de dos char: un -61 y un -79. Esta función
//   devuelve solamente este último, y al ser utilizada esto debe ser tenido en
//   cuenta notando que antes debe agregarse un -61 para que el caracter pueda
//   ser representado correctamente.
char indice_a_caracter(int indice);

// swap: char* int int -> void
// Recibe una palabra y dos índices,
// Intercambia los caracteres en las posiciones de dichos índices.
void swap(char* palabra, int i, int j);

// transponer_adyacentes: char* int -> void
// Recibe una palabra y un índice, transpone la letra en el índice i-ésimo de
// la palabra y la siguiente.
// - Nota: tenemos en cuenta que los caracteres especiales están representados
//   por 2 caracteres, por lo que si se tiene palabra == ñoño, i == 0, se
//   intercambian los 2 caracteres correspondientes a la ñ con la o como se
//   esperaría. Se realizan consideraciones similares cuando la siguiente letra
//   es un caracter especial.
void transponer_adyacentes(char* palabra, int i);

#endif  // __UTIL_H_
