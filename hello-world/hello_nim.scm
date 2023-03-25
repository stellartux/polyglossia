#!/usr/bin/env -S guile -s
# code visible to Nim

echo "Hello from Nim!";

#[ Code visible to Scheme !#

(define (echo s) (display s) (newline))
(echo "Hello from Scheme!")

; code visible to Nim and Scheme ]#

(echo "Hello from Nim and Scheme!")
