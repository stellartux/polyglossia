#!/usr/bin/env lua
_ = #{} --[[ code visible to Julia

then = true
assert(x) = x || error()

evenfibonacci() = (last([1 0] * [1 2; 2 3] ^ n) for n in Iterators.countfrom(0))

#= code visible to Lua ]]

local function evenfibonacci()
    local a, b = 1, 0
    return function()
        a, b = a + 2 * b, 2 * a + 3 * b
        return b
    end
end

local println = print

local function sum(...)
    local result = 0
    for x in ... do
        result = result + x
    end
    return result
end

local Iterators = {
    takewhile = function(predicate, iter, t, k)
        return function()
            k = iter(t, k)
            if predicate(k) then return k end
        end
    end
}

local
-- code visible to Julia and Lua =#

function euler2(limit)
    return sum(Iterators.takewhile(function(n) return n < limit end, evenfibonacci()))
end

assert(euler2(100) == 2 + 8 + 34)
println(euler2(4000000))
