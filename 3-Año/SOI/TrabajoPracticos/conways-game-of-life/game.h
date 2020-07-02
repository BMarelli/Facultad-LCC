#if !defined(__GAME__)
#define __GAME__

#include "board.h"

// Representamos un juego como un puntero a un board_t y la cantidad de generaciones a computar.
typedef struct {
  board_t *board;
  unsigned int cycles;
} game_t;

// Crea un juego vacío.
game_t *game_init();

// Recibe un puntero a un game_t y un nombre de archivo,
// Carga la información del archivo a la estructura y devuelve 0.
// Si el archivo no existe, devuelve 1.
int game_load(game_t *game, const char *filename);

// Recibe un puntero a un game_t y un nombre de archivo,
// Escribe la información del tablero al archivo.
void game_write(game_t *game, const char *filename);

// Recibe un puntero a un game_t y el número de hilos a utilizar,
// Computa las siguientes generaciones del juego.
void game_run(game_t *game, const int nproc);

// DEFINICIONES DE LA CÁTEDRA
/* Cargamos el juego desde un archivo */
game_t *loadGame(const char *filename);

/* Guardamos el tablero 'board' en el archivo 'filename' */
void writeBoard(board_t board, const char *filename);

/* Simulamos el Juego de la Vida de Conway con tablero 'board' la cantidad de
ciclos indicados en 'cycles' en 'nuprocs' unidades de procesamiento*/
board_t *congwayGoL(board_t *board, unsigned int cycles, const int nuproc);

#endif  // __GAME__
