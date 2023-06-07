#!/usr/bin/env lua
_ = #{} --[[ code visible to Julia

then = true
assert(x) = x || error()
or(a, b) = a || b
or(b) = Base.Fix2(or, b)
Base.:*(a, f::Base.Fix2{typeof(or),<:Any}) = f(a)

#= code visible to Lua ]]

local function filter(predicate, iter, t, k)
    return function()
        repeat
            k = iter(t, k)
        until k == nil or predicate(k)
        return k
    end
end

local println = print

local function range(start, stop)
    return function(stop, i)
        i = i + 1
        if i <= stop then return i end
    end, stop, start - 1
end

local function sum(...)
    local result = 0
    for x in ... do
        result = result + x
    end
    return result
end

-- code visible to Julia and Lua =#

function euler1(n)
    return sum(filter(function(a)
        return (a % 3 == 0)or(a % 5 == 0)
    end, range(1, n - 1)))
end

assert(euler1(10) == 23)
println(euler1(1000))
