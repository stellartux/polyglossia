#!/usr/bin/env python3
#| code visible to Python

print("Hello from \x1b[96mPython\x1b[m!")
puts = print
msg = "Hello from Common Lisp and Python!"

""" code visible to Common Lisp |#

(defun msg () "Hello from Common Lisp and Python!")
(defun puts (x) (princ x) (terpri))
(puts "Hello from Common Lisp!")

;"""# code visible to Common Lisp and Python

(puts (msg))
