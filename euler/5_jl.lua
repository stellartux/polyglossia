#!/usr/bin/env lua
local _ = #_G --[[ code here is only visible to Julia

using Primes: isprime

#= code here is only visible to Lua ]]

local jl = require("jl")
local println = jl.println
local prod = jl.prod
local filter = jl.filter
local isprime = jl.Primes.isprime
local UnitRange = jl.UnitRange

-- code here is visible to Julia and Lua =#

println(prod(filter(isprime, UnitRange(1, 20))) * 24)
