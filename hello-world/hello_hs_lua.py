--[[],1][1];''' Code visible to Haskell

main = do
    putStrLn "Hello from \x1b[95mHaskell\x1b[m!"

{- Code visible to Lua ]]

local function void(...) end
local function putStrLn(...) print(...) return void end
putStrLn("Hello from \x1b[94mLua\x1b[m!")

--[[ Code visible to Python '''

putStrLn = print

def main():
    print("Hello from \x1b[96mPython\x1b[m!")

# Code visible to Haskell, Lua and Python ]]--}
    putStrLn ("Hello from \x1b[95mHaskell\x1b[m, \x1b[94mLua\x1b[m and \x1b[96mPython\x1b[m!")

--[[],0][1];'''
{-'''
if __name__ == "__main__":
    main()
#]]--}
