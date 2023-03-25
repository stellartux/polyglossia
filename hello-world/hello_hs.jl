(#=) = True

println :: String -> IO ()
println = putStrLn

main :: IO ()
main = do
    println ("Hello from \x1b[95mHaskell\x1b[m!")

{- code only visible to Julia =#)
println("Hello from \x1b[35mJulia\x1b[m!")

# code visible to Haskell and Julia -}
    println("Hello from \x1b[95mHaskell\x1b[m and \x1b[35mJulia\x1b[m!")
