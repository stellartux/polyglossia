#!/usr/bin/env -S nim r
#| code visible to Nim

echo "Hello from Nim!"

#[ code visible to Common Lisp |#

(defun echo (s) (princ s) (terpri))
(echo "Hello from Common Lisp!")

; code visible to Common Lisp and Nim ]#

(echo "Hello from Common Lisp and Nim!")
