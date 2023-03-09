#ifndef __COSMOPOLITAN__
#include <stdio.h>
#endif /* Code only visible to Julia

hello() = println("Hello from \x1b[35mJulia\x1b[m!")
puts = println
start = nothing

#= Code only visible to C */
#define function int
#define start {
#define end }

void hello() { puts("Hello from \x1b[90mC\x1b[m!"); }

// Code visible to C and Julia =#

function main()
start
    hello();
    puts("Hello from \x1b[90mC\x1b[m and \x1b[35mJulia\x1b[m!");
end

#if 0
main()
#endif
