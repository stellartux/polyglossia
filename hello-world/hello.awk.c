#ifndef __COSMOPOLITAN__
#include <stdlib.h>
#include <stdio.h>
#endif
#define BEGIN void main()
#define function void
#define IS_C 1
#define print puts

function sayHello() {
  printf("Hello from \x1b[%s\x1b[m!\n", IS_C ? "90mC" : "30mawk");
}

BEGIN {
  sayHello();
  print("Hello from \x1b[30mawk\x1b[m and \x1b[90mC\x1b[m!");
  exit(0);
}
