#include <stdio.h>
#include <string.h>
#include <sys/sysinfo.h>

#include "game.h"

#define OUT_EXT ".final"
#define OUT_EXT_LEN 6

int main(int argc, char const *argv[]) {
  if (argc < 2 || argc > 3) {
    printf("Error: la cantidad de argumentos es incorrecta.\n");
    return 1;
  }

  game_t *game = game_init();

  if (game_load(game, argv[1])) {
    printf("Error: el archivo %s no existe.\n", argv[1]);
    return 1;
  }

  game_run(game, get_nprocs());

  if (argc == 3) {
    game_write(game, argv[2]);
  } else {
    char output[strlen(argv[1]) + OUT_EXT_LEN + 1];

    strcpy(output, argv[1]);
    char *ext = strchr(output, '.');
    if (ext == NULL)
      strcat(output, OUT_EXT);
    else
      strcpy(strchr(output, '.'), OUT_EXT);

    game_write(game, output);
  }

  board_destroy(game->board);
  free(game);

  return 0;
}
