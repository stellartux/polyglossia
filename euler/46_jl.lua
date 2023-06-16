#!/usr/bin/env lua
local _ = #_G --[[
# code here is only visible to Julia

using Base.Iterators: countfrom
using Primes: isprime
and = *
not = !
then = true

function searchfirst(fn, iter)
    for v in iter
        if fn(v)
            return v
        end
    end
end

#= code here is only visible to Lua ]]

local Jl = require("jl")
local all = Jl.all
local countfrom = Jl.countfrom
local isqrt = Jl.isqrt
local map = Jl.map
local println = Jl.println
local UnitRange = Jl.UnitRange

local isprime = require("ji/primes").isprime

local function searchfirst(fn, ...)
    for value in ... do
        if fn(value) then return value end
    end
end

local
-- code here is visible to Julia and Lua =#

function euler46()
    local function iscomposite(n)
        return not(isprime(n))
    end
    return searchfirst(function(i)
        return iscomposite(i)and(all(iscomposite,
            map(function(n) return i - 2 * n ^ 2 end,
                UnitRange(1, isqrt(i - 1)))))
    end, countfrom(9, 2))
end

println(euler46())
