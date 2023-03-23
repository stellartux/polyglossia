#!/usr/bin/env ruby
#|
#[ code visible to Ruby

alias echo puts
echo "Hello from Ruby!"

=begin code visible to Nim ]#

echo "Hello from Nim!"

#[ code visible to Common Lisp |#

(defun echo (s) (princ s) (terpri))
(echo "Hello from Common Lisp!")

#|
=end # code visible to Common Lisp, Nim and Ruby ]## |#

(echo "Hello from Common Lisp, Nim and Ruby!")
