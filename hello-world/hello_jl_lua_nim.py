#!/usr/bin/env lua
(#{} and ""):byte()--[[
#=
#[ code visible to Python
) 

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

-- code visible to Julia, Lua, Nim and Python # ]## =## '''

echo("Hello from \x1b[35mJulia\x1b[m, \x1b[94mLua\x1b[m, \x1b[93mNim\x1b[m and \x1b[96mPython\x1b[m!")
