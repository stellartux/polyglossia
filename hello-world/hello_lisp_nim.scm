#!/usr/bin/env -S guile -s
#| code visible to Nim

echo "Hello from Nim!";

#[ code visible to Common Lisp |#

(defun echo (s) (princ s) (terpri))
(echo "Hello from Common Lisp!")

#| Code visible to Scheme !#

(define (echo s) (display s) (newline))
(echo "Hello from Scheme!")

; code visible to Common Lisp, Nim and Scheme |#;]#

(echo "Hello from Common Lisp, Nim and Scheme!")
