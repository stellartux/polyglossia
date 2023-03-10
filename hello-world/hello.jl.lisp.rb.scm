#!/usr/bin/env ruby
#|
#= Code visible to Ruby

puts "Hello from Ruby!"

=begin code visible to Julia =#

macro puts_str(s)
    :(println($(s)))
end
puts"Hello from Julia!"

#= Code visible to Common Lisp |#

(defun puts (x) (princ x) (terpri))
(puts "Hello from Common Lisp!")

#| Code visible to Scheme !#

(define (puts x) (display x) (newline))
(puts "Hello from Scheme!")

#!
=end
# Code visible to Common Lisp, Julia, Ruby and Scheme |#;!#;=#

(puts"Hello from Common Lisp, Julia, Ruby and Scheme!")
