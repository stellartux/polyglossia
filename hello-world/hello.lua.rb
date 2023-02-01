#!/usr/bin/env ruby
_=#_G --[[
0 # Code here is only visible to Ruby

puts "Hello from Ruby!"

=begin Code here is only visible to Lua ]]

puts = print
puts "Hello from Lua!"

--[[
=end # Code here is visible to Lua and Ruby ]]

puts "Hello from Lua and Ruby!"
