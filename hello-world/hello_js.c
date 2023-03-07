// ` Code visible to C

#ifndef __COSMOPOLITAN__
#include <stdio.h>
#include <stdlib.h>
#endif
#define function int
void sayHello() {
  puts("Hello from \x1b[90mC\x1b[m!");
}

#if 0 // Code visible to JavaScript `

const puts = globalThis.print || globalThis.console.log;
const sayHello = (s = "Hello from \x1b[33mJavaScript\x1b[m!") => puts(s);

// `
#endif // Code visible to C and JavaScript `

function main() {
  sayHello();
  puts("Hello from \x1b[90mC\x1b[m and \x1b[33mJavaScript\x1b[m!");
}

// main();
