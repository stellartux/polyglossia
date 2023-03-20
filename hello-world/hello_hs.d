#!/usr/bin/env runghc

void _(){-0>1?writeln(""):0;} // code visible to D

import std.stdio;

int main() {
    int n = 0;
    writeln("Hello from \x1b[31mD\x1b[m!");

/* code visible to Haskell -}
    = ()

writeln = putStrLn

main = do
    writeln("Hello from \x1b[95mHaskell\x1b[m!")

-- code visible to D and Haskell */

    writeln("Hello from \x1b[31mD\x1b[m and \x1b[95mHaskell\x1b[m!");

    --n;/*
{-*/
    return 0;
}//-}
