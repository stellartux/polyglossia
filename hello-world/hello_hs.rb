(#)=(){- Code visible to Ruby
)
puts "Hello from \x1b[91mRuby\x1b[m!"

=begin Code visible to Haskell -}

puts = putStrLn
main = do
    puts "Hello from \x1b[95mHaskell\x1b[m!"

{- Code visible to Haskell and Ruby
=end #-}
    puts "Hello from \x1b[95mHaskell\x1b[m and \x1b[91mRuby\x1b[m!"
