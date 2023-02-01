#!/usr/bin/env lua
_=#_G--[[
0 # Code here is only visible to Julia

println("Hello from Julia!")

#= Code here is only visible to Lua ]]

local println = print
println("Hello from Lua!")

-- Code here is visible to Lua and Julia =#

println("Hello from Lua and Julia!")
