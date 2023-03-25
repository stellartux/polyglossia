--[[],0][1];''' Code visible to Haskell

puts = putStrLn
main = do
    puts "Hello from \x1b[95mHaskell\x1b[m!"

{- Code visible to Ruby '

puts "Hello from \x1b[91mRuby\x1b[m!"

=begin Code visible to Lua ]]

local puts = print
puts("Hello from \x1b[94mLua\x1b[m!")

--[[ Code visible to Python '''

puts = print
def main():
    puts("Hello from \x1b[36mPython\x1b[m!")

    '''
=end ' '''# Code visible to Haskell, Lua, Python and Ruby ]]--}

    puts("Hello from \x1b[95mHaskell\x1b[m, \x1b[94mLua\x1b[m, \x1b[91mRuby\x1b[m and \x1b[36mPython\x1b[m!")

--[[],0][1];'''
{-' '''
if __name__ == "__main__":
    main()
#'#]]--}
