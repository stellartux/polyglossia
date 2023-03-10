#!/usr/bin/env ruby
;'!#; code visible to Scheme

(define (puts x) (display x) (newline))
(puts "Hello from \x1b[31mScheme\x1b[m!")

#| code visible to Ruby '

puts "Hello from \x1b[91mRuby\x1b[m!"

# code visible to Ruby and Scheme |#

(puts "Hello from \x1b[91mRuby\x1b[m and \x1b[31mScheme\x1b[m!")
