//\
/* Code visible to C

#ifndef __COSMOPOLITAN__
#include <stdio.h>
#include <stdlib.h>
#endif
#define function int
#define print puts

void sayHello() {
  print("Hello from \x1b[90mC\x1b[m!");
}

/*/ // Code visible to JavaScript

var print;
function sayHello() {
  if (print) {
    print("Hello from \x1b[33mqjs\x1b[m!");
  } else if (this == undefined) {
    print = console.log;
    print("Hello from \x1b[33mdeno\x1b[m!");
  } else if (this.display) {
    this.console = { log: print = function(s) { display(s); newline(); }};
    print("Hello from \x1b[33mguile\x1b[m!");
  } else {
    print = console.log;
    print("Hello from \x1b[33mnode\x1b[m!");
  }
}

// Code visible to C and JavaScript */

function main() {
  sayHello();
  print("Hello from \x1b[90mC\x1b[m and \x1b[33mJavaScript\x1b[m!");
}

//\
main();
