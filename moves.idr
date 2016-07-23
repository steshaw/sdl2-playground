module Main

import SDL2 as SDL2
import System as System

fail : (msg: String) -> IO ()
fail msg = do
  err <- getError
  fPutStr stderr $ msg ++ " failed:" ++ err
  fflush stderr
  System.exit 1

width : Int
width = 640

height : Int
height = 480

squareSize : Int
squareSize = 50

main : IO ()
main = (do
  renderer <- SDL2.init width height
  let x = ((width `div` 2) - (squareSize `div` 2))
  let y = ((height `div` 2) - (squareSize `div` 2))
  loop renderer x y 0 0
  SDL2.destroyRenderer renderer
  quit)
    where
      loop : Renderer -> Int -> Int -> Int -> Int -> IO ()
      loop renderer x y dx dy = do

        True <- SDL2.setRendererDrawColor renderer 0 0 111 255
          | fail "setRendererDrawColor"
        SDL2.rendererClear renderer
        SDL2.filledRect renderer x y squareSize squareSize 255  0  0  128
        SDL2.rendererPresent renderer

        pollEvent <- SDL2.pollEvent
        pending <- SDL2.pollEvent_pending pollEvent
        if pending > 0 then do
          type <- SDL2.pollEvent_event_type pollEvent
          if type == QUIT then System.exit 0
          else if type == KEYDOWN then do
            sym <- SDL2.pollEvent_event_key_keysym_sym pollEvent
            if sym == KEY_ESCAPE then System.exit 0
            else if sym == KEY_UP then do
              loop renderer x y dx (-1)
            else if sym == KEY_RIGHT then do
              loop renderer x y 1 dy
            else if sym == KEY_DOWN then do
              loop renderer x y dx 1
            else if sym == KEY_LEFT then do
              loop renderer x y (-1) dy
            else putStrLn ("Other key: " ++ show sym)
          else if type == KEYUP then do
            sym <- SDL2.pollEvent_event_key_keysym_sym pollEvent
            if sym == KEY_UP then do
              loop renderer x y dx 0
            else if sym == KEY_RIGHT then do
              loop renderer x y 0 dy
            else if sym == KEY_DOWN then do
              loop renderer x y dx 0
            else if sym == KEY_LEFT then do
              loop renderer x y 0 dy
            else pure () -- putStrLn ("Other key: " ++ show sym)
          else pure ()
        else pure ()
        loop renderer (x + dx) (y + dy) dx dy
