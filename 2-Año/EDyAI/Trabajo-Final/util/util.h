#if !defined(__UTIL_H__)
#define __UTIL_H__
#include "../slist/slist.h"

#define _RED_ "\033[1;31m"    // printf color rojo
#define _GREEN_ "\033[1;32m"  // printf color verde
#define _RESET_ "\033[0m"     // printf normal

// En esta estructura se guarda un arreglo el cual representa una matriz, un
// entero (n) y un arreglo (visitados).
// El mapa se representa con una matriz simetrica. Para acceder el costo del
// camino de la ciudad_i a la ciudad_j, se usa matriz[n * ciudad_i + ciudad_j]
// donde n es la cantidad de ciudades
// El arrglo de visitados es usado para llevar un registro de que ciudades
// fueron visitadas al momento de buscar un camino
// Si quiero ver si la ciudad_i fue visitadad, se pueded ver usando
// visitados[ciudad_i] y si es 0 no fue visitada y 1 si lo fue
typedef struct _MatrizCostos {
  int n;
  int* matriz;
  int* visitados;
} * MatrizCostos;

// parsear_archivo: char* SList MatrizCostos -> SList
// Recibe el nombre del archivo, una Slist y una MatrizCostos.
// Guarda los nombres de las ciudades en la Slist (en orden de como las lee) y
// luego completa la matriz simetrica de la MatrizCostos con la informacion del
// archivo.
// Devuelve la SList con las ciudades
SList parsear_archivo(char* archivo, SList listaCiudades, MatrizCostos matriz);

// escribir_archivo: char* int* SList -> int
// Recibe el nombre del archivo, un arreglo que representa el camino con el
// menor costo, un SList con las ciudades y una MatrizCostos.
// Crear o edita un archivo con el nombre pasado y impeime el costo con los
// pasos del camino con el menor costo.
// Devuelve 1 si el archivo se creo o edito exitosamente o 0 en el caso
// contrario
int escribir_archivo(char* archivo, int* minimo, SList lista,
                     MatrizCostos matriz);

// matrizcostos_destruir: MatrizCostos -> void
// Recibe una MatrizCostos.
// Destruye la MatrizCostos.
void matrizcostos_destruir(MatrizCostos matriz);

// matriz_costos: MatrizCostos -> void
// Recibe una MatrizCostos
// Imprime la MatrizCostos->matriz
void matrizcostos_imprimir(MatrizCostos matriz);

// copiar_cadena: char* -> char*
// Recibe una cadena.
// Copia la cadena.
// Devuelve la nueva cadena
char* copiar_cadena(char* cadena);

// matriz_crear: int -> int*
// Recibe un entero.
// Crea un arreglo de enteros de tamaño (n*n) inicializado en 0.
// Devuelve el arreglo
int* matriz_crear(int n);

#endif  // __UTIL_H__
