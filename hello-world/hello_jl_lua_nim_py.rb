#!/usr/bin/env ruby
(#{} and ""):byte()--[[
#=
#[
''' code visible to Ruby '
)

alias echo puts
echo("Hello from \x1b[91mRuby\x1b[m!")

=begin # code visible to Python ''')

echo = print
echo("Hello from \x1b[96mPython\x1b[m!")

''' code visible to Nim ]# discard false)

echo("Hello from \x1b[93mNim\x1b[m!")

#[ code visible to Julia =#)

echo = println
echo("Hello from \x1b[35mJulia\x1b[m!")

#= code visible to Lua ]]

echo = print
echo("Hello from \x1b[94mLua\x1b[m!")

--[[
=end 
# code visible to Julia, Lua, Nim, Python and Ruby # ]## =## '''# ]]

echo("Hello from \x1b[35mJulia\x1b[m, \x1b[94mLua\x1b[m, \x1b[93mNim\x1b[m, \x1b[96mPython\x1b[m and \x1b[91mRuby\x1b[m!")
