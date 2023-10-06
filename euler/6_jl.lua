#!/usr/bin/env lua
local _ = #_G --[[
#= code here is only visible to Lua ]]

local jl = require("jl")
local println = jl.println
local sum = jl.sum
local UnitRange = jl.UnitRange
local map = jl.map

-- code here is visible to Julia and Lua =#

function square(x) return x * x end

println(square(sum(UnitRange(1, 100))) - sum(map(square, UnitRange(1, 100))))
