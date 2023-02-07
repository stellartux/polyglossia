#!/usr/bin/env ruby
(#{} and ""):len() --[[
""" Code visible only to Ruby ")

puts("Hello from Ruby!")

=begin Code visible only to Lua ]]

puts = print
puts("Hello from Lua!")

--[[ Code visible only to Python """)#=

puts = print
puts("Hello from Python!")

''' Code visible only to Julia =#

puts = println
puts("Hello from Julia!")

#=
=end # Code visible to Julia, Lua, Python and Ruby '''# =##]]

puts("Hello from \x1b[35mJulia\x1b[m, \x1b[94mLua\x1b[m, \x1b[36mPython\x1b[m and \x1b[31mRuby\x1b[m!")
