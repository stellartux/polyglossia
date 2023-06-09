#!/usr/bin/env lua
local _ = #_G --[[ code here is only visible to Julia

then = true
arg = ARGS
assert(::Nothing, msg) = error(msg)
assert(x, _...) = x
tointeger(s::AbstractString) = tryparse(Int, s)
tointeger(n) = n
math = (tointeger = tointeger,)

coins = (200, 100, 50, 20, 10, 5, 2, 1)
coincache = Dict{Int,Dict{Int,Int}}(n => Dict{Int,Int}() for n in coins)

#= code here is only visible to Lua ]]
local Jl = require("euler/jl")
local get = Jl.get
local map = Jl.map
local println = Jl.println
local sum = Jl.sum
local UnitRange = Jl.UnitRange
local coins = { 200, 100, 50, 20, 10, 5, 2, 1 }
local coincache = {
    [1] = {},
    [2] = {},
    [5] = {},
    [10] = {},
    [20] = {},
    [50] = {},
    [100] = {},
    [200] = {}
}
local
-- code here is visible to Julia and Lua =#

function coinsums(n, j)
    return get(function()
        return sum(map(function(i)
            local coin = coins[i]
            if n > coin then
                return coinsums(n - coin, i)
            elseif n == coin then
                return 1
            end
            return 0
        end, UnitRange(j, 8)))
    end, coincache[coins[j]], n)
end

println(coinsums(assert(math.tointeger(arg[1]), "expected an integer"), 1))
