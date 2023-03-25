#!/bin/sh
echo = --[[ >>/dev/null && true<<---[[
    putStrLn -- code visible to Haskell

main = do
    putStrLn "Hello from \x1b[95mHaskell\x1b[m!"

{- code visible to Lua ]]

print
putStrLn = print
putStrLn("Hello from \x1b[94mLua\x1b[m!")

--[[
# code visible to Shell

putStrLn() { printf "$1\n"; }
putStrLn "Hello from \x1b[32mShell\x1b[m!"

# Code visible to Haskell, Lua and Shell ]]--}

    putStrLn "Hello from \x1b[95mHaskell\x1b[m, \x1b[94mLua\x1b[m and \x1b[32mShell\x1b[m!"
