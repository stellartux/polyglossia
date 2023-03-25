#!/usr/bin/env -S guile -s
{- code visible to Scheme !#

(define (putStrLn x) (display x) (newline))
(putStrLn "Hello from \x1b[31mScheme\x1b[m!")

#| code visible to Haskell -}

main = do
  putStrLn "Hello from \x1b[95mHaskell\x1b[m!"

-- code visible to Haskell and Scheme |#

  (putStrLn "Hello from \x1b[95mHaskell\x1b[m and \x1b[31mScheme\x1b[m!")
