#!/usr/bin/env ruby
#|
#= code visible to Ruby

puts "Hello from Ruby!"

=begin code visible to Julia =#

macro puts_str(s)
    :(println($(s)))
end
puts"Hello from Julia!"

#= Code visible to Common Lisp |#

(defun puts (x) (princ x) (terpri))
(puts "Hello from Common Lisp!")

#|
=end
# Code visible to Common Lisp, Julia and Ruby |#;=#

(puts"Hello from Common Lisp, Julia and Ruby!")
