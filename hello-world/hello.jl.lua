#!/usr/bin/env lua
_=#_G--[[
0 # Code here is only visible to Julia

println("Hello from \x1b[35mJulia\x1b[m!")

#= Code here is only visible to Lua ]]

local println = print
println("Hello from \x1b[94mLua\x1b[m!")

-- Code here is visible to Lua and Julia =#

println("Hello from \x1b[94mLua\x1b[m and \x1b[35mJulia\x1b[m!")
