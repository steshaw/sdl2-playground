module Main

import Config

%include C "sdl2.h"
%link    C "sdl2.o"

export
data Renderer = MkRenderer Ptr

export
init : Int -> Int -> IO Renderer
init w h = do
  ptr <- foreign FFI_C "init" (Int -> Int -> IO Ptr) w h
  return $ MkRenderer ptr

{-
void filledRect(
  void *r_in,
  int x, int y, int w, int h,
  int r, int g, int b, int a);

int pollEventsForQuit();
-}

main : IO ()
main = do
  renderer <- Main.init 640 480
  pure ()
