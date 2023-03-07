--[[ Code only visible to Haskell

main = do
    putStrLn "Hello from \27[95mHaskell\27[m!"

{- Code only visible to Lua ]]
local putStrLn = print
putStrLn "Hello from \27[94mLua\27[m!"

-- Code visible to Haskell and Lua -}
    putStrLn "Hello from \27[95mHaskell\27[m and \27[94mLua\27[m!"
