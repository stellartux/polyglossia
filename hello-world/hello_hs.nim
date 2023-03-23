#!/usr/bin/env runghc
var _ = {-0} # code visible to Nim

echo "Hello from \x1b[93mNim\x1b[m!"

(#[ code visible to Haskell -}
  ()

echo = putStrLn
main = do
 echo "Hello from \x1b[95mHaskell\x1b[m!"

 (-- code visible to Haskell and Nim ]#

  echo "Hello from \x1b[95mHaskell\x1b[m and \x1b[93mNim\x1b[m!")
