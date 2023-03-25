void f () {-0;}/* code visible to Haskell -}
    = ()

puts = putStrLn

{- code visible to C */

#ifndef __COSMOPOLITAN__
#include <stdio.h>
#endif

// code visible to C and Haskell -}

int main () {-0;

    // code visible to C
    puts("Hello from \x1b[90mC\x1b[m!");

    /* code visible to Haskell -}
    = do {
        putStrLn "Hello from \x1b[95mHaskell\x1b[m!";

    -- code visible to C and Haskell */
        puts("Hello from \x1b[90mC\x1b[m and \x1b[95mHaskell\x1b[m!");
    };

unsigned g () {-0;}/*-}
    = ()

main = int () ()

-- */
