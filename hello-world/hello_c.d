//\
/+
#if 0
// code visible to D +/

import std.stdio;

void sayHello() {
    writeln("Hello from \x1b[31mD\x1b[m!");
}

/+ code visible to C
#endif

#include <stdio.h>
#define writeln puts

void sayHello() {
    writeln("Hello from \x1b[90mC\x1b[m!");
}

// code visible to C and D +/

int main() {
    sayHello();
    writeln("Hello from \x1b[90mC\x1b[m and \x1b[31mD\x1b[m!");
    return 0;
}
