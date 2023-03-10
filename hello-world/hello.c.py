#if 0
#endif /* code visible to Python

puts = print
def main():
    puts("Hello from \x1b[96mPython\x1b[m!")

    """ code visible to C */

#ifndef __COSMOPOLITAN__
#include <stdio.h>
#endif

int main() {
    puts("Hello from \x1b[90mC\x1b[m!");

    // code visible to C and Python """

    puts("Hello from \x1b[90mC\x1b[m and \x1b[96mPython\x1b[m!");

#if 0
if __name__ == "__main__":
    main() #/*
""" */
#endif
}//"""
