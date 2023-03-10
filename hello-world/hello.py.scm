#!/usr/bin/env -S guile -s
# code visible to Python

print("Hello from \x1b[96mPython\x1b[m!")
puts = print
msg = "Hello from \x1b[31mScheme\x1b[m and \x1b[96mPython\x1b[m!"

""" code visible to Scheme !#

(define (msg) "Hello from \x1b[31mScheme\x1b[m and \x1b[96mPython\x1b[m!")
(define (puts x) (display x) (newline))
(puts "Hello from \x1b[31mScheme\x1b[m!");

;"""# code visible to \x1b[31mScheme\x1b[m and Python

(puts (msg))
