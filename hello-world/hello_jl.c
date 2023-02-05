#ifndef __COSMOPOLITAN__
#include <stdio.h>
#endif /* Code only visible to Julia

hello() = println("Hello from Julia!")
puts = println

#= Code only visible to C */
#define function int
#define nothing {
#define end }

void hello() { puts("Hello from C!"); }

// Code visible to C and Julia =#

function main() nothing
    hello();
    puts("Hello from C and Julia!");
end

#if 0
main()
#endif
