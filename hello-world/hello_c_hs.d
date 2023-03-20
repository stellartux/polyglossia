int n = 0;
void _(){--n/+1;// code visible to C
}
#include <stdio.h>
#define writeln puts

// +/;} import std.stdio: writeln;

int main() {
//\
    writeln("Hello from \x1b[31mD\x1b[m!");
//\
/*
    writeln("Hello from \x1b[90mC\x1b[m!");

/* code visible to Haskell -}
    = ()

writeln = putStrLn

main = do
    writeln("Hello from \x1b[95mHaskell\x1b[m!")

-- code visible to C, D and Haskell */

    writeln("Hello from \x1b[90mC\x1b[m, \x1b[31mD\x1b[m and \x1b[95mHaskell\x1b[m!");

    --n;/*
{-*/
    return 0;
}//-}
