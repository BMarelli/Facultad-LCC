#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "slist/slist.h"
#include "util/util.h"

// obtener_camino: int int* int* MatrizCostos -> void
// Recibe un entero que representa el nivel, dos arreglos de enteros que
// representan caminos (uno el actual y el otro el minimo), una MatrizCostos.
// Itera por cada uno de los posibles caminos del nivel actual y se llama
// recursivamente a si misma con un nivel mayor,
// Cuando el nivel llega al final del camino, se fija si el camino es el costo
// actual es menor que el costo minimo, si es asi el minimo pasa a ser el camino
// actual
// Aclaracion: Los arreglos de enteros actual y minimo son de longitud n+1 (n es
// la cantidad de ciudades), donde el ultimo elementos es el costo de ese camino
void obtener_camino(int N, int* actual, int* minimo, MatrizCostos matriz) {
  int nCiudades = matriz->n;
  if (N == nCiudades - 1) {
    int costo = matriz->matriz[(nCiudades * actual[N - 1]) + actual[N]];
    if (costo && (costo + actual[nCiudades]) < minimo[nCiudades]) {
      memcpy(minimo, actual, (nCiudades + 1) * sizeof(int));
      minimo[nCiudades] += costo;
    }
  } else {
    for (int i = 1; i < nCiudades; i++) {
      if (!matriz->visitados[i]) {
        int costo = matriz->matriz[(nCiudades * actual[N - 1]) + i];
        if (costo && (costo + actual[nCiudades]) < minimo[nCiudades]) {
          actual[nCiudades] += costo;
          matriz->visitados[i] = 1;
          actual[N] = i;
          obtener_camino(N + 1, actual, minimo, matriz);
          actual[nCiudades] -= costo;
          matriz->visitados[i] = 0;
          actual[N] = 0;
        }
      }
    }
  }
}

// resolver_mapa: int* int* MatrizCostos -> int*
// Recibe dos arreglos de enteros que representan caminos (uno el actual y el
// otro el minimo), una MatrizCostos. Fija en el camino actual la primera y
// ultima ciudad (realizando todas las permutuaciones posible, sin repetir) y
// luego llama a la funcion obtener_camino con un nivel de profundidad 2 con las
// ciudades fijas.
// Devuelve el arreglo de enteros que representa el camino de menor costo
int* resolver_mapa(int* actual, int* minimo, MatrizCostos matriz) {
  int n = matriz->n;
  for (int i = 1; i < n - 1; i++) {
    int costo = matriz->matriz[i];
    if (costo) {
      actual[1] = i;
      matriz->visitados[i] = 1;
      for (int j = i + 1; j < n; j++) {
        int _costo = matriz->matriz[(n * j)];
        if (_costo) {
          actual[n - 1] = j;
          actual[n] = (costo + _costo);
          matriz->visitados[j] = 1;
          obtener_camino(2, actual, minimo, matriz);
          matriz->visitados[j] = 0;
          actual[n] -= _costo;
        }
      }
      actual[n] -= costo;
      matriz->visitados[i] = 0;
    }
  }
  return minimo;
}

int main(int argc, char* argv[]) {
  if (argc != 3) {
    printf(_RED_ "La cantidad de argumentos es incorrecta!\n");
    printf("MODO DE USO: %s [entrada.txt] [salida.txt]\n", argv[0]);
    return 1;
  }
  // Para medir el tiempo que se tarda en encontrar el camino
  __clock_t start, end;
  double timer;

  SList ciudades = slist_crear();
  MatrizCostos matrizCostos = malloc(sizeof(struct _MatrizCostos));
  ciudades = parsear_archivo(argv[1], ciudades, matrizCostos);
  if (slist_vacia(ciudades)) {
    printf(_RED_ "Se profujo un error al leer el archivo: %s\n", argv[1]);
    slist_destruir(ciudades);
    matrizcostos_destruir(matrizCostos);
    return 1;
  }
  printf("Los datos del archivo: %s, han sido ingresados\n", argv[1]);

  start = clock();
  int* actual = calloc((matrizCostos->n + 1), sizeof(int));
  int* minimo = calloc((matrizCostos->n + 1), sizeof(int));
  minimo[matrizCostos->n] = __INT_MAX__;

  minimo = resolver_mapa(actual, minimo, matrizCostos);
  end = clock();
  timer = ((double)(end - start)) / CLOCKS_PER_SEC;
  printf(_GREEN_ "Se ha encontrado un camino, en: %fs\n"_RESET_, timer);

  if (!escribir_archivo(argv[2], minimo, ciudades, matrizCostos)) {
    printf(_RED_ "Se profujo un error al escribir el archivo: %s\n", argv[2]);
    free(actual);
    free(minimo);
    slist_destruir(ciudades);
    matrizcostos_destruir(matrizCostos);
    return 1;
  }
  printf("El archivo: %s, ha sido creado\n", argv[2]);

  free(actual);
  free(minimo);
  slist_destruir(ciudades);
  matrizcostos_destruir(matrizCostos);
  return 0;
}
