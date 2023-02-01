#!/usr/bin/env ruby
_=#_G --[[
0 #= Code visible only to Ruby

puts "Hello from Ruby!"

=begin Code visible only to Julia =#

puts = println
puts("Hello from Julia!")

#= Code visible only to Lua ]]

puts = print
puts("Hello from Lua!")

--[[
=end # Code visible to Julia, Lua and Ruby =##]]
puts("Hello from Julia, Lua and Ruby!")
