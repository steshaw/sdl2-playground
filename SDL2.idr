module SDL2

import Config
import public Constants

%include C "sdl2.h"
%link    C "sdl2.o"

export
data Renderer = MkRenderer Ptr

export
data Surface = MkSurface Ptr

export
data Texture = MkTexture Ptr

export
data PollEvent = MkPollEvent Ptr

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

--
-- PollEvent
--

export
pollEvent : IO PollEvent
pollEvent = do
  pollEvent <- foreign FFI_C "idris_sdl2_pollEvent" (IO Ptr)
  return $ MkPollEvent pollEvent

export
pollEvent_pending : PollEvent -> IO Int
pollEvent_pending (MkPollEvent pollEvent) =
  foreign FFI_C "idris_sdl2_pollEvent_pending" (Ptr -> IO Int) pollEvent

export
pollEvent_event_type : PollEvent -> IO Bits32
pollEvent_event_type (MkPollEvent pollEvent) =
  foreign FFI_C "idris_sdl2_pollEvent_event_type" (Ptr -> IO Bits32) pollEvent

export
pollEvent_event_key_keysym_sym : PollEvent -> IO Bits32
pollEvent_event_key_keysym_sym (MkPollEvent pollEvent) =
  foreign FFI_C "idris_sdl2_pollEvent_event_key_keysym_sym" (Ptr -> IO Bits32) pollEvent

--

export
pollEventsForQuit : IO Bool
pollEventsForQuit = do
  quit <- foreign FFI_C "pollEventsForQuit" (IO Int)
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

-- XXX: Ignores last two arguments for now: srcRect and dstRect.
export
renderCopy : Renderer -> Texture -> IO Int
renderCopy (MkRenderer renderer) (MkTexture texture) =
  foreign FFI_C "SDL_RenderCopy" (Ptr -> Ptr -> Ptr -> Ptr -> IO Int)
          renderer texture null null

export
renderClear : Renderer -> IO Int
renderClear (MkRenderer renderer) =
  foreign FFI_C "SDL_RenderClear" (Ptr -> IO Int) renderer

export
renderPresent : Renderer -> IO ()
renderPresent (MkRenderer renderer) =
  foreign FFI_C "SDL_RenderPresent" (Ptr -> IO ()) renderer

export
loadBMP : (bmpPath : String) -> IO Surface
loadBMP bmpPath = do
  surface <- foreign FFI_C "SDL_LoadBMP" (String -> IO Ptr) bmpPath
  return $ MkSurface surface

export
createTextureFromSurface : Renderer -> (bitmap : Surface) -> IO Texture
createTextureFromSurface (MkRenderer renderer) (MkSurface bmp) = do
  texture <- foreign FFI_C "SDL_CreateTextureFromSurface" (Ptr -> Ptr -> IO Ptr) renderer bmp
  return $ MkTexture texture

export
destroyRenderer : Renderer -> IO ()
destroyRenderer (MkRenderer renderer) =
  foreign FFI_C "SDL_DestroyRenderer" (Ptr -> IO ()) renderer

export
freeSurface : Surface -> IO ()
freeSurface (MkSurface surface) =
  foreign FFI_C "SDL_FreeSurface" (Ptr -> IO ()) surface

export
quit : IO ()
quit = foreign FFI_C "SDL_Quit" (IO ())
