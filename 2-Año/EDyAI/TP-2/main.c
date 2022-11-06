#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "trie/trie.h"

// Para compilar el programa utilizamos un Makefile:
// $ make

// MODO DE USO:
// $ ./main [diccionario.txt] [texto.txt] [salida.txt]
// Genera CANTIDAD_SUGERENCIAS sugerencias para aquellas palabras en [texto.txt]
// que no se encuentran el [diccionario.txt]. Escribe estas sugerencias a
// [salida.txt].
// Genera sugerencias aplicando recursivamente las siguientes técnicas:
// - Agregar letras
// - Eliminar letras
// - Intercambiar letras
// - Trasponer letras adyacentes
// - Separar palabras
// El archivo [diccionario.txt] debe tener una palabra por línea. Los únicos
// caracteres permitidos en este archivo son las letras del abecedario, y las
// letras á, é, í, ó, ú, ü y ñ. Asimismo, no distinguimos entre mayúsculas y
// minúsculas.
// El archivo [texto.txt] debe finalizar con un salto de línea.
// Por cada sugerencia encontrada, se escrribe a [salida.txt] texto con el
// siguiente formato:
//    Línea N: "palabra", no se encuentra en el diccionario
//    Quizas quizo decir: "sugerencia1", "sugerencia2", "sugerencia3",
//    "sugerencia4","sugerencia5"

// Representa la cantidad de sugerencias a generar por cada palabra incorrecta
// encontrada.
#define CANTIDAD_SUGERENCIAS 5

// cargar_diccionario: Trie* char* -> int
// Recibe un puntero a un Trie y el nombre de archivo de un diccionario,
// Si el archivo existe, agrega todas las palabras al Trie, y devuelve 1.
// Si no, devuelve 0.
int cargar_diccionario(Trie* trie, char* nombreDeArchivo) {
  FILE* diccionario = fopen(nombreDeArchivo, "r");

  if (diccionario == NULL) return 0;

  char buffer[50];

  while (fscanf(diccionario, "%s", buffer) != EOF) trie_agregar(trie, buffer);

  fclose(diccionario);

  return 1;
}

int main(int argc, char* argv[]) {
  if (argc != 4) {
    printf("Error: el número de argumentos ingresados es incorrecto.\n");
    printf("Modo de uso: %s [diccionario.txt] [texto.txt] [salida.txt]\n",
           argv[0]);
    return 1;
  }

  Trie* trie = trie_crear();

  clock_t timer;
  timer = clock();
  if (cargar_diccionario(trie, argv[1])) {
    printf("Diccionario %s cargado exitosamente.\n", argv[1]);
  } else {
    printf("Se ha producido un error cargando el diccionario %s.\n", argv[1]);
  }
  timer = clock() - timer;
  printf("CARGA DE DICCIONARIO: %lfs\n", ((double)timer) / CLOCKS_PER_SEC);

  FILE* texto = fopen(argv[2], "r");
  if (texto == NULL) {
    printf("Se ha producido un error leyendo el texto %s.\n", argv[2]);
    return 1;
  }

  FILE* salida = fopen(argv[3], "w");
  if (salida == NULL) {
    printf("Se ha producido un error creando el archivo de salida %s.\n",
           argv[3]);
    return 1;
  }

  timer = clock();
  char buffer[50], c;
  int linea = 1, i = 0, insertandoCaracterEspecial = 0;
  int cantPalabrasLeidas = 0, cantPalabrasIncorrectas = 0;
  while ((c = fgetc(texto)) != EOF) {
    if (c == -61)
      insertandoCaracterEspecial = 1;
    else {
      if (caracter_a_indice(c, insertandoCaracterEspecial) != -1) {
        if (insertandoCaracterEspecial) {
          buffer[i++] = -61;
          insertandoCaracterEspecial = 0;
        }
        buffer[i++] = c;
      } else if (i != 0) {
        cantPalabrasLeidas++;

        buffer[i] = '\0';
        if (!trie_contiene(trie, buffer)) {
          cantPalabrasIncorrectas++;

          Sugerencias* sugerencias =
              trie_sugerir(trie, buffer, CANTIDAD_SUGERENCIAS);
          fprintf(salida, "Línea %d, \"%s\" no está en el diccionario.\n",
                  linea, buffer);
          fprintf(salida, "Quizás quiso decir: %s", sugerencias->datos[0]);
          for (int i = 1; i < CANTIDAD_SUGERENCIAS; i++) {
            fprintf(salida, ", %s", sugerencias->datos[i]);
          }
          fprintf(salida, "\n\n");
          sugerencias_destruir(sugerencias);
        }

        i = 0;
        if (c == '\n' || c == '\r') linea++;
      }
    }
  }
  timer = clock() - timer;
  printf("CORRECCIÓN DEL TEXTO: %lfs\n", ((double)timer) / CLOCKS_PER_SEC);
  printf("CANTIDAD DE PALABRAS LEÍDAS: %d\n", cantPalabrasLeidas);
  printf("CANTIDAD DE PALABRAS INCORRECTAS: %d\n", cantPalabrasIncorrectas);

  fclose(texto);
  fclose(salida);

  trie_destruir(trie);

  return 0;
}
