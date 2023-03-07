(#=)=(){-
''' Code visible to Ruby ')

puts "Hello from \x1b[91mRuby\x1b[m!"

=begin # Code visible to Python ''')

puts = print
puts("Hello from \x1b[36mPython\x1b[m!")

def main():
    ''' Code visible to Julia =#)

puts = println
puts("Hello from \x1b[35mJulia\x1b[m!")

#= Code visible to Haskell -}

puts = putStrLn
main = do
    puts "Hello from \x1b[95mHaskell\x1b[m!"

{- Code visible to Haskell, Julia, Python and Ruby
=end # =##'''#-}
    puts("Hello from \x1b[95mHaskell\x1b[m, \x1b[35mJulia\x1b[m, \x1b[91mRuby\x1b[m and \x1b[36mPython\x1b[m!")

(#==)=(){-
''' ' ''')
if __name__ == "__main__":
    main()
#')# =#)#-}
