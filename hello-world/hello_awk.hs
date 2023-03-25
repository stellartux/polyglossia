#!/usr/bin/awk
{-0} # code visible to Awk

function putStrLn(x) { print x }

BEGIN {
    print "Hello from \x1b[30mAwk\x1b[m!"

# code visible to Haskell

#-}main = do {-
#-} putStrLn "Hello from \x1b[95mHaskell\x1b[m!" {-

# code visible to Awk and Haskell -}

    putStrLn("Hello from \x1b[30mAwk\x1b[m and \x1b[95mHaskell\x1b[m!")

{-0}
    exit 0
}#-}
