#!/usr/bin/env ruby
#= Code here is only visible to Ruby

puts "Hello from \x1b[91mRuby\x1b[m!"

=begin # Code here is only visible to Julia =#
puts = println
puts("Hello from \x1b[35mJulia\x1b[m!")

#=
=end # Code here is visible to Julia and Ruby =#
puts("Hello from \x1b[35mJulia\x1b[m and \x1b[91mRuby\x1b[m!")
