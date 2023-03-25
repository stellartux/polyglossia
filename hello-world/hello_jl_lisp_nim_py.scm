#!/usr/bin/env -S guile -s
#|
#[
#= code visible to Python

echo = print
echo("Hello from Python!")
msg = "Hello from Common Lisp, Julia, Nim, Python and Scheme!"

""" code visible to Nim ]#

echo "Hello from Nim!"

#[ code visible to Common Lisp |#

(defun echo (s) (princ s) (terpri))
(echo "Hello from Common Lisp!")
(defun msg () "Hello from Common Lisp, Julia, Nim, Python and Scheme!")

#| Code visible to Julia =#

echo = println
echo("Hello from Julia!") 

# code visible to Julia and Nim ]#

const msg = "Hello from Common Lisp, Julia, Nim, Python and Scheme!"

#[
#= Code visible to Scheme !#

(define (echo s) (display s) (newline))
(echo "Hello from Scheme!")
(define (msg) "Hello from Common Lisp, Julia, Nim, Python and Scheme!")

; code visible to Common Lisp, Julia, Nim, Python and Scheme |#;]## =##"""

(echo(msg))
