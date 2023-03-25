#!/usr/bin/env ruby
#| code visible to Ruby

puts "Hello from Ruby!"

=begin code visible to Common Lisp |#

(defun puts (x) (princ x) (princ #\Newline))
(puts "Hello from Common Lisp!")

#|
=end # code visible to Common Lisp and Ruby |#

(puts "Hello from Common Lisp and Ruby!")
