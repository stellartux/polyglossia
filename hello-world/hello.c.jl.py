#if 0
#endif /*
_=0 #= code visible to Python

puts = print

def main():
    puts("Hello from \x1b[96mPython\x1b[m!")

    """ code visible to Julia =#

puts = println
function main()
    println("Hello from \x1b[35mJulia\x1b[m!")

#= code visible to C */

#ifndef __COSMOPOLITAN__
#include <stdio.h>
#endif

int main() {
    puts("Hello from \x1b[90mC\x1b[m!");

// code visible to C, Julia and Python =##"""

    puts("Hello from \x1b[90mC\x1b[m, \x1b[35mJulia\x1b[m and \x1b[96mPython\x1b[m!");

#if 0
_=0 #= code visible to Python

if __name__ == "__main__":
    main() #/*

""" code visible to Julia =#

end
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end

#= code visible to C */
#endif

}

// =# #"""
