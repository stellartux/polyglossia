;/* Code visible to Scheme

(define msg "Hello from \x1b[90mC\x1b[m and \x1b[31mScheme\x1b[m!")
(define (puts x) (display x) (newline))
(puts "Hello from \x1b[31mScheme\x1b[m!")

#| Code visible to C */

#ifndef __COSMOPOLITAN__
#include <stdio.h>
#endif
#define msg ("Hello from \x1b[90mC\x1b[m and \x1b[31mScheme\x1b[m!")
int main() {
  puts("Hello from \x1b[90mC\x1b[m!");

// Code visible to C and Scheme |#

(puts msg); }
