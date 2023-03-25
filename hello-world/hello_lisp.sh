#!/bin/sh
#| code visible to Shell

echo "Hello from Shell!"

true<<=end
code visible to Common Lisp |#

(defun echo (x) (princ x) (princ #\Newline))
(echo "Hello from Common Lisp!")

#|
=end
# code visible to Common Lisp and Shell |#

(echo "Hello from Common Lisp and Shell!")
