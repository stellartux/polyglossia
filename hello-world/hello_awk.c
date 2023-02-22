#include <stdlib.h>
#include <stdio.h>
#define BEGIN void main()
#define function void
#define IS_C 1
#if 0
function puts(s) { print s }
#endif

function sayHello() {
  printf("Hello from \x1b[%s\x1b[m!\n", IS_C ? "90mC" : "30mawk");
}

BEGIN {
  sayHello();
  puts("Hello from \x1b[30mawk\x1b[m and \x1b[90mC\x1b[m!");
  exit(0);
}
