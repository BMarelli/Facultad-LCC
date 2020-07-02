#if !defined(__BOARD__)
#define __BOARD__

#define DEAD_CHAR 'X'
#define DEAD 0
#define ALIVE_CHAR 'O'
#define ALIVE 1

#include <stdio.h>
#include <stdlib.h>

// Representamos un tablero con la siguiente estructura.
// Usamos una matriz de tamaño 2 x nrows x ncols, de modo que el tablero actual alterna entre world[0] y world[1]
// según el valor current.
// De esta manera, si el tablero actual es world[current] podemos escribir la siguiente generación en world[!current]
// a medida que se recorre el tablero.
typedef struct {
  size_t ncols, nrows;
  char*** world;
  unsigned int current;
} board_t;

// Recibe un size_t nrows y un size_t ncols,
// Crea y devuelve un puntero a un board_t de tamaño nrows x ncols.
board_t* board_init(size_t nrows, size_t ncols);

// Recibe un puntero a un board_t y un puntero a un archivo,
// Lee el archivo y guarda los datos en el tablero actual (world[current]).
void board_fill(board_t* board, FILE* file);

// Recibe un puntero a un tablero, un size_t row y un size_t col,
// Devuelve el valor que se encuentra en la posición (row, col) del tablero actual (world[current]).
char board_get(board_t* board, size_t row, size_t col);

// Recibe un puntero a un board_t, un size_t row, un size_t col, y un char state,
// Escribe state en la posición (row, col) del siguiente tablero (world[!current]).
void board_set(board_t* board, size_t row, size_t col, char state);

// Recibe un puntero a un board_t, un size_t row y un size_t col,
// Devuelve la cantidad de vecinos vivos de la celda (row, col) en el tablero actual (world[current]).
char board_get_neighbors(board_t* board, size_t row, size_t col);

// Recibe un puntero a un board_t y un puntero a un archivo,
// Escribe el tablero actual (world[current]) en el archivo.
void board_write(board_t* board, FILE* file);

// Recibe un puntero a un board_t,
// Lo destruye.
void board_destroy(board_t* board);
#endif
