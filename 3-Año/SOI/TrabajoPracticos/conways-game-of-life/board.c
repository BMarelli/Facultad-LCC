#include "board.h"

#define up(row, nrows) (row ? row - 1 : nrows - 1)
#define down(row, nrows) (row == nrows - 1 ? 0 : row + 1)
#define left(col, ncols) (col ? col - 1 : ncols - 1)
#define right(col, ncols) (col == ncols - 1 ? 0 : col + 1)

board_t* board_init(size_t nrows, size_t ncols) {
  board_t* board = malloc(sizeof(board_t));
  board->nrows = nrows;
  board->ncols = ncols;
  board->world = malloc(sizeof(char**) * 2);
  board->world[0] = malloc(sizeof(char*) * nrows);
  board->world[1] = malloc(sizeof(char*) * nrows);
  for (size_t i = 0; i < nrows; i++) {
    board->world[0][i] = malloc(sizeof(char) * ncols);
    board->world[1][i] = malloc(sizeof(char) * ncols);
  }
  board->current = 0;

  return board;
}

void board_fill(board_t* board, FILE* file) {
  char line[board->ncols + 1];

  for (size_t i = 0; i < board->nrows; i++) {
    fscanf(file, "%s", line);

    for (size_t j = 0; j < board->ncols; j++) {
      if (line[j] == ALIVE_CHAR)
        board->world[0][i][j] = ALIVE;
      else if (line[j] == DEAD_CHAR)
        board->world[0][i][j] = DEAD;

      board->world[1][i][j] = DEAD;
    }
  }
}

char board_get(board_t* board, size_t row, size_t col) { return board->world[board->current][row][col]; }

char board_get_neighbors(board_t* board, size_t row, size_t col) {
  char** present = board->world[board->current];
  size_t m = board->nrows;
  size_t n = board->ncols;

  return present[up(row, m)][col] + present[up(row, m)][right(col, n)] + present[row][right(col, n)] +
         present[down(row, m)][right(col, n)] + present[down(row, m)][col] + present[down(row, m)][left(col, n)] +
         present[row][left(col, n)] + present[up(row, m)][left(col, n)];
}

void board_set(board_t* board, size_t row, size_t col, char state) { board->world[!board->current][row][col] = state; }

void board_write(board_t* board, FILE* file) {
  char** present = board->world[board->current];

  for (size_t i = 0; i < board->nrows; i++) {
    for (size_t j = 0; j < board->ncols; j++) {
      fprintf(file, "%c", present[i][j] ? ALIVE_CHAR : DEAD_CHAR);
    }
    fprintf(file, "\n");
  }
}

void board_destroy(board_t* board) {
  for (size_t i = 0; i < board->nrows; i++) {
    free(board->world[0][i]);
    free(board->world[1][i]);
  }
  free(board->world[0]);
  free(board->world[1]);
  free(board->world);
  free(board);
}
