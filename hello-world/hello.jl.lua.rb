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
puts("Hello from \x1b[35mJulia, \x1b[94mLua\x1b[m and \x1b[91mRuby\x1b[m!")
