#include <stdio.h>
#include <stdbool.h>
#include <idris_rts.h>
#include <SDL2/SDL.h>

void filledRect(void *r_in,
                int x, int y, int w, int h,
                int r, int g, int b, int a)
{
    SDL_Renderer* renderer = (SDL_Renderer*)r_in;
    int rc1 = SDL_SetRenderDrawColor(renderer, r, g, b, a);
    if (rc1 != 0) {
      fprintf(stderr, "SDL_SetRenderDrawColor failed: %s\n", SDL_GetError());
      exit(1);
    }
    SDL_Rect rect = { x, y, w, h };
    int rc2 = SDL_RenderFillRect(renderer, &rect);
    if (rc2 != 0) {
      fprintf(stderr, "SDL_RenderFillRect failed: %s\n", SDL_GetError());
      exit(1);
    }
}

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
    fprintf(stderr, "Unable to create renderer: %s\n", SDL_GetError());
    exit(1);
  }

  if (SDL_SetRenderDrawBlendMode(renderer, SDL_BLENDMODE_BLEND) != 0) {
    fprintf(stderr, "SDL_BlendMode failed: %s\n", SDL_GetError());
    exit(1);
  };

  return renderer;
}

int pollEventsForQuit() {
  SDL_Event e;
  while (SDL_PollEvent(&e)) {
    switch (e.type) {
      case SDL_QUIT:
        return 1;
        break;
      case SDL_KEYDOWN:
        if (e.key.keysym.sym == SDLK_ESCAPE) {
          return 1;
        }
        break;
    }
  }
  return 0;
}

// Capture all the results of SDL_PollEvent.
typedef struct {
  int pending; // Either 0 or 1 according to SDL2 documentation.
  SDL_Event event;
} PollEvent;

PollEvent *idris_sdl2_pollEvent() {
  PollEvent *pollEvent = idris_alloc(sizeof(PollEvent));
  pollEvent->pending = SDL_PollEvent(&pollEvent->event);
  return pollEvent;
}

int idris_sdl2_pollEvent_pending(PollEvent *pollEvent) {
  return pollEvent->pending;
}

int idris_sdl2_pollEvent_event_type(PollEvent *pollEvent) {
  return pollEvent->event.type;
}

int idris_sdl2_pollEvent_event_key_keysym_sym(PollEvent *pollEvent) {
  return pollEvent->event.key.keysym.sym;
}
