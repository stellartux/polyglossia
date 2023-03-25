--0;''' Code visible to Haskell

main = do
    putStrLn "Hello from \x1b[95mHaskell\x1b[m!"

{- Code visible to Python '''

putStrLn = print

def main():
    putStrLn("Hello from \x1b[36mPython\x1b[m!")

# Code visible to Haskell and Python -}
    putStrLn("Hello from \x1b[95mHaskell\x1b[m and \x1b[36mPython\x1b[m!")

b'''=(){-'''
if __name__ == "__main__":
    main()
#-}
