module Main

import System as System
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
-}
-- XXX: This is not a primitive SDL2 function.
export
filledRect : Renderer -> 
             (x : Int) -> (y : Int) -> (w : Int) -> (h : Int) -> 
             (r : Bits8) -> (g : Bits8) -> (b : Bits8) -> (a : Bits8)
             -> IO ()
filledRect (MkRenderer renderer) x y w h r g b a = do
  foreign FFI_C "filledRect"
    (Ptr -> 
     Int -> Int -> Int -> Int ->
     Bits8 -> Bits8 -> Bits8 -> Bits8 -> 
     IO ())
    renderer x y w h r g b a

export
pollEventsForQuit : IO Bool
pollEventsForQuit = do
  quit <- foreign FFI_C "pollEventsForQuit" (IO (Int))
  return $ quit == 1

export
setRendererDrawColor : 
  Renderer -> 
  (r : Bits8) -> (g : Bits8) -> (b : Bits8) -> (a : Bits8) -> IO Bool
setRendererDrawColor (MkRenderer renderer) r g b a = do
  result <- foreign FFI_C "SDL_SetRenderDrawColor"
            (Ptr -> Bits8 -> Bits8 -> Bits8 -> Bits8 -> IO Int)
            renderer r g b a
  return (result == 0)

export
getError : IO String
getError = foreign FFI_C "SDL_GetError" (IO String)

export
rendererClear : Renderer -> IO Int
rendererClear (MkRenderer renderer) =
  foreign FFI_C "SDL_RenderClear" (Ptr -> IO Int) renderer

export
rendererPresent : Renderer -> IO ()
rendererPresent (MkRenderer renderer) =
  foreign FFI_C "SDL_RenderPresent" (Ptr -> IO ()) renderer

export
destroyRenderer : Renderer -> IO ()
destroyRenderer (MkRenderer renderer) =
  foreign FFI_C "SDL_DestroyRenderer" (Ptr -> IO ()) renderer

export
quit : IO ()
quit = foreign FFI_C "SDL_Quit" (IO ())

fail : (msg: String) -> IO ()
fail msg = do
  err <- getError
  fPutStr stderr $ msg ++ " failed:" ++ err
  fflush stderr
  System.exit 1

main : IO ()
main = (do
  renderer <- Main.init 640 480
  loop renderer
  destroyRenderer renderer
  quit)
    where
      loop : Renderer -> IO ()
      loop renderer = do
        False <- pollEventsForQuit | pure ()
        True <- setRendererDrawColor renderer 0 0 111 255
          | fail "setRendererDrawColor"
        rendererClear renderer
        filledRect renderer  100  100  50  50  255  0  0  128
        rendererPresent renderer
        loop renderer
