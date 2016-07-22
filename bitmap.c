#include <stdio.h>
#include <stdbool.h>
#include <SDL2/SDL.h>

SDL_Renderer *init(int w, int h) {
  if (SDL_Init(SDL_INIT_VIDEO) != 0) {
    fprintf(stderr, "Cannot initialise SDL: %s\n", SDL_GetError());
    exit(1);
  }

  SDL_Window *window = SDL_CreateWindow(
    "Hello World!", 
    SDL_WINDOWPOS_CENTERED, 
    SDL_WINDOWPOS_CENTERED, 
    w, h,
    SDL_WINDOW_SHOWN
  );
  if (window == NULL) {
    fprintf(stderr, "Unable to create window: %s\n", SDL_GetError());
    exit(1);
  }

  SDL_Renderer *renderer = SDL_CreateRenderer(
    window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC
  );
  if (renderer == NULL) {
    SDL_DestroyWindow(window);
    fprintf(stderr, "Unable to create renderer: %s\n", SDL_GetError());
    SDL_Quit();
    exit(1);
  }

  return renderer;
}

int main(int argc, char* args[]) {
  SDL_Renderer *renderer = init(640, 480);

  SDL_Surface *bmp = SDL_LoadBMP("hello.bmp");
  if (bmp == NULL) {
      SDL_DestroyRenderer(renderer);
      // SDL_DestroyWindow(window);
      fprintf(stderr, "Unable to load hello.bmp: %s\n", SDL_GetError());
      SDL_Quit();
      exit(1);
  }

  SDL_Texture *texture = SDL_CreateTextureFromSurface(renderer, bmp);
  SDL_FreeSurface(bmp);
  if (texture == NULL) {
      SDL_DestroyRenderer(renderer);
      // SDL_DestroyWindow(window);
      fprintf(stderr, "SDL_CreateTextureFromSurface failed: %s\n", SDL_GetError());
      SDL_Quit();
      exit(1);
  }

  bool quit = false;
  while (!quit) {
    SDL_Event e;
    while (SDL_PollEvent(&e)) {
      switch (e.type) {
        case SDL_QUIT:
          quit = true;
          break;
        case SDL_KEYDOWN:
          if (e.key.keysym.sym == SDLK_ESCAPE) {
            quit = true;
          }
          break;
      }
    }
    int rc1 = SDL_SetRenderDrawColor(renderer, 0, 0, 0, 0);
    if (rc1 != 0) {
      fprintf(stderr, "SDL_SetRenderDrawColor failed: %s\n", SDL_GetError());
      exit(1);
    }
    SDL_RenderClear(renderer);
    SDL_RenderCopy(renderer, texture, NULL, NULL); // Draw texture.
    SDL_RenderPresent(renderer); // Update screen.
  }

  SDL_DestroyTexture(texture);
  SDL_DestroyRenderer(renderer);
  SDL_Quit();

  return 0;
}
