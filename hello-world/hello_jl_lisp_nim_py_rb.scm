#!/usr/bin/env ruby
#|
#[
#= code visible to Python and Ruby

msg = "Hello from Common Lisp, Julia, Nim, Python, Ruby and Scheme!"

""" code visible to Ruby "

alias echo puts
echo("Hello from Ruby!")

=begin code visible to Python """

echo = print
echo("Hello from Python!")

""" code visible to Nim ]#

echo "Hello from Nim!"

#[ code visible to Common Lisp |#

(defun echo (s) (princ s) (terpri))
(echo "Hello from Common Lisp!")
(defun msg () "Hello from Common Lisp, Julia, Nim, Python, Ruby and Scheme!")

#| Code visible to Julia =#

echo = println
echo("Hello from Julia!") 

# code visible to Julia and Nim ]#

const msg = "Hello from Common Lisp, Julia, Nim, Python, Ruby and Scheme!"

#[
#= Code visible to Scheme !#

(define (echo s) (display s) (newline))
(echo "Hello from Scheme!")
(define (msg) "Hello from Common Lisp, Julia, Nim, Python, Ruby and Scheme!")

#!
=end # code visible to Common Lisp, Julia, Nim, Python, Ruby and Scheme !#;|#;]## =##"""

(echo(msg))
