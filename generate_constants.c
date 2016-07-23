#include <SDL2/SDL.h>

void constant(char name[], int value) {
  printf("public export\n");
  printf("%s : Bits32\n", name);
  printf("%s = %d\n\n", name, value);
}

int main(int argc, char *argv[]) {
/*
  printf("sizeof(enum Fred) = %lu\n", sizeof(enum Fred));

  int keyUp = 1073741906;
  printf("keyUp = %d\n", keyUp);
*/

  printf("module Constants\n\n");
  constant("QUIT", SDL_QUIT);
  constant("KEYDOWN", SDL_KEYDOWN);
  constant("KEYUP", SDL_KEYUP);

  constant("KEY_ESCAPE", SDLK_ESCAPE);
  constant("KEY_UP", SDLK_UP);
  constant("KEY_RIGHT", SDLK_RIGHT);
  constant("KEY_DOWN", SDLK_DOWN);
  constant("KEY_LEFT", SDLK_LEFT);
}
