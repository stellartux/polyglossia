#ifndef __COSMOPOLITAN__
#include <stdio.h>
#endif
#define echo puts /*

# code visible to Nim

echo("Hello from \x1b[93mNim\x1b[m!")

#[ code visible to C */

int main() {
echo("Hello from \x1b[90mC\x1b[m!");

// code visible to C and Nim ]#

echo("Hello from \x1b[90mC\x1b[m and \x1b[93mNim\x1b[m!");

#if 0
#endif /*
#[*/
}//]#
