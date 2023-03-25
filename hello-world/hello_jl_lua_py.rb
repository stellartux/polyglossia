#!/usr/bin/env ruby
(#{} and ""):len() --[[
""" Code visible only to Ruby ")

puts("Hello from \x1b[91mRuby\x1b[m!")

=begin Code visible only to Lua ]]

puts = print
puts("Hello from \x1b[94mLua\x1b[m!")

--[[ Code visible only to Python """)#=

puts = print
puts("Hello from \x1b[36mPython\x1b[m!")

''' Code visible only to Julia =#

puts = println
puts("Hello from \x1b[35mJulia\x1b[m!")

#=
=end # Code visible to Julia, Lua, Python and Ruby '''# =##]]

puts("Hello from \x1b[35mJulia\x1b[m, \x1b[94mLua\x1b[m, \x1b[36mPython\x1b[m and \x1b[91mRuby\x1b[m!")
