#!/usr/bin/env ruby
#|
#[
true and '\'' # code visible to Ruby

alias echo puts
echo "Hello from Ruby!"

=begin code visible to Shell '

echo "Hello from Shell!"

: code visible to Nim  <<=end
]#

echo "Hello from Nim!"

#[ code visible to Common Lisp |#

(defun echo (s) (princ s) (terpri))
(echo "Hello from Common Lisp!")

#|
=end
# code visible to Common Lisp, Nim, Ruby and Shell ]## |#

(echo "Hello from Common Lisp, Nim, Ruby and Shell!")
