#!/bin/sh
echo = putStrLn {- >>/dev/null && true<<{#-}{-
# code visible to Haskell -}

main = do
    putStrLn "Hello from \x1b[95mHaskell\x1b[m!"
 
{- code visible to Shell
{#-}{-

putStrLn() {
    printf "$1\n"
}
putStrLn "Hello from \x1b[32mShell\x1b[m!"

# code visible to Haskell and Shell -}

    putStrLn "Hello from \x1b[95mHaskell\x1b[m and \x1b[32mShell\x1b[m!"
