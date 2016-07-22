module Main

import SDL2 as SDL2
import System as System

fail : (msg: String) -> IO ()
fail msg = do
  err <- getError
  fPutStr stderr $ msg ++ " failed:" ++ err
  fflush stderr
  System.exit 1

main : IO ()
main = (do
  renderer <- SDL2.init 640 480
  loop renderer
  SDL2.destroyRenderer renderer
  quit)
    where
      loop : Renderer -> IO ()
      loop renderer = do
        False <- SDL2.pollEventsForQuit | pure ()
        True <- SDL2.setRendererDrawColor renderer 0 0 111 255
          | fail "setRendererDrawColor"
        SDL2.rendererClear renderer
        SDL2.filledRect renderer  100  100  50  50  255  0  0  128
        SDL2.rendererPresent renderer
        loop renderer
