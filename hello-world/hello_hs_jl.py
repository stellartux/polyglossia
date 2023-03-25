(#=)=(){- Code visible to Python
)
println = print
def main():
    print("Hello from \x1b[36mPython\x1b[m!")

    ''' Code visible to Haskell -}

println :: String -> IO ()
println = putStrLn

main :: IO ()
main = do
    println ("Hello from \x1b[95mHaskell\x1b[m!")

{- code visible to Julia =#)
println("Hello from \x1b[35mJulia\x1b[m!")

# code visible to Haskell, Julia and Python '''#-}
    println("Hello from \x1b[95mHaskell\x1b[m, \x1b[35mJulia\x1b[m and \x1b[36mPython\x1b[m!");

(#)=();{-
)#=
if __name__ == "__main__":
    main()
# =##-}
