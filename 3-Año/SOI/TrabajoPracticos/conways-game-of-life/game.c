#include "game.h"

#include <pthread.h>

#include "barrier.h"

#define HORIZONTAL 0
#define VERTICAL 1
#define MIN(a, b) (a < b ? a : b)
#define MAX(a, b) (a > b ? a : b)

typedef struct {
  game_t *game;
  int id;
  int nthreads;
  int orientation;
  barrier_t *barrier;
} thread_args;

game_t *game_init() {
  game_t *game = malloc(sizeof(game_t));
  return game;
}

int game_load(game_t *game, const char *filename) {
  FILE *file = fopen(filename, "r");
  if (file == NULL) return 1;

  size_t cycles, nrows, ncols;
  fscanf(file, "%lu %lu %lu", &cycles, &nrows, &ncols);

  game->cycles = cycles;
  game->board = board_init(nrows, ncols);
  board_fill(game->board, file);

  fclose(file);

  return 0;
}

void game_write(game_t *game, const char *filename) {
  FILE *file = fopen(filename, "w+");

  board_write(game->board, file);

  fclose(file);
}

void next_gen(board_t *board, int i, int j) {
  char state = board_get(board, i, j);
  char neighbors = board_get_neighbors(board, i, j);

  if (neighbors == 3 || (state == ALIVE && neighbors == 2))
    board_set(board, i, j, ALIVE);
  else
    board_set(board, i, j, DEAD);
}

void *game_run_thread(void *args) {
  thread_args *_args = args;

  game_t *game = _args->game;
  int id = _args->id;
  int orientation = _args->orientation;
  int nthreads = _args->nthreads;
  barrier_t *barrier = _args->barrier;

  for (unsigned int iter = 0; iter < game->cycles; iter++) {
    if (orientation == HORIZONTAL) {
      size_t i = id;
      while (i < game->board->nrows) {
        for (size_t j = 0; j < game->board->ncols; j++) next_gen(game->board, i, j);
        i += nthreads;
      }
    } else {
      size_t j = id;
      while (j < game->board->ncols) {
        for (size_t i = 0; i < game->board->nrows; i++) next_gen(game->board, i, j);
        j += nthreads;
      }
    }

    barrier_wait(barrier);
  }

  return NULL;
}

void on_broadcast(void *args) {
  game_t *game = (game_t *)args;

  game->board->current = !game->board->current;
}

void game_run(game_t *game, const int nproc) {
  size_t nthreads = MIN((unsigned)nproc, MAX(game->board->nrows, game->board->ncols));
  int orientation = game->board->nrows >= game->board->ncols ? HORIZONTAL : VERTICAL;

  pthread_t threads[nthreads];
  thread_args *args[nthreads];

  barrier_t *barrier = barrier_init(nthreads, on_broadcast, game);

  for (unsigned int i = 0; i < nthreads; i++) {
    args[i] = malloc(sizeof(thread_args));
    args[i]->game = game;
    args[i]->id = i;
    args[i]->orientation = orientation;
    args[i]->nthreads = nthreads;
    args[i]->barrier = barrier;

    pthread_create(&threads[i], NULL, game_run_thread, (void *)args[i]);
  }

  for (size_t i = 0; i < nthreads; i++) {
    pthread_join(threads[i], NULL);
    free(args[i]);
  }

  barrier_destroy(barrier);
}

// DEFINICIONES DE LA CÁTEDRA

game_t *loadGame(const char *filename) {
  game_t *game = game_init();

  game_load(game, filename);

  return game;
}

void writeBoard(board_t board, const char *filename) {
  FILE *file = fopen(filename, "w+");

  board_write(&board, file);

  fclose(file);
}

board_t *congwayGoL(board_t *board, unsigned int cycles, const int nuproc) {
  game_t *game = game_init();
  game->board = board;
  game->cycles = cycles;

  game_run(game, nuproc);

  free(game);

  return board;
}
