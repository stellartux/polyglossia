#!/usr/bin/env lua
local _ = #{} --[[
then = true   #=]]

local ARGS = arg
local function first(xs) return xs[1] end
local Int = math.tointeger
local function parse(T, s) return T(s) end
local println = print

local Iterators = {
    drop = function(iter, n)
        for _ = 1, n do iter() end
        return iter
    end
}

local function StepRange(start, step, stop)
    local i = start - step
    return function()
        i = i + step
        if i <= stop then return i end
    end
end

local function range(start, stop, length)
    return StepRange(start, (stop - start) / (length - 1), stop)
end

local function map(fn, i, t, k)
    return function()
        local v
        k, v = i(t, k)
        if k then
            if v == nil then
                return fn(k)
            else
                return k, fn(v)
            end
        end
    end
end

local function sum(...)
    local result = 0
    for x in ... do result = result + x end
    return result
end

local -- n must be odd and greater than 1 =#
function corners(n)
    return Int(sum(Iterators.drop(range((n - 2) ^ 2, n ^ 2, 5), 1)))
end

function euler28(n)
    return 1 + sum(map(corners, StepRange(3, 2, n)))
end

println(euler28(parse(Int, first(ARGS))))
