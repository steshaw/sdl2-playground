#ifndef SDL2_H
#define SDL2_H

#include <SDL2/SDL.h>

void filledRect(
  void *r_in,
  int x, int y, int w, int h,
  int r, int g, int b, int a);

SDL_Renderer *init(int w, int h);

int pollEventsForQuit();

//
// SDL_PollEvent
//

typedef struct PollEvent PollEvent;

PollEvent *idris_sdl2_pollEvent();

int idris_sdl2_pollEvent_pending(PollEvent *pollEvent);
int idris_sdl2_pollEvent_event_type(PollEvent *pollEvent);
int idris_sdl2_pollEvent_event_key_keysym_sym(PollEvent *pollEvent);

#endif
