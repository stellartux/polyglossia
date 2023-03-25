;/* Code visible to Common Lisp

(defvar msg "Hello from C and Common Lisp!")
(defun puts (x) (princ x) (terpri))
(puts "Hello from Common Lisp!")

#| Code visible to C */

#ifndef __COSMOPOLITAN__
#include <stdio.h>
#endif
#define msg ("Hello from C and Common Lisp!")
int main() {
  puts("Hello from C!");

// Code visible to C and Common Lisp |#

(puts msg); }
