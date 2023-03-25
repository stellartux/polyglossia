#!/usr/bin/env ruby
_=#_G --[[
0 # Code here is only visible to Ruby

puts "Hello from \x1b[91mRuby\x1b[m!"

=begin Code here is only visible to Lua ]]

puts = print
puts "Hello from \x1b[94mLua\x1b[m!"

--[[
=end # Code here is visible to Lua and Ruby ]]

puts "Hello from \x1b[94mLua\x1b[m and \x1b[91mRuby\x1b[m!"
