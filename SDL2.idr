module SDL2

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

-- XXX: This is not a primitive SDL2 function.
export
filledRect :
  Renderer ->
  (x : Int) -> (y : Int) -> (w : Int) -> (h : Int) ->
  (r : Bits8) -> (g : Bits8) -> (b : Bits8) -> (a : Bits8) ->
  IO ()
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