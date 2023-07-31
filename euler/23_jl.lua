local _ = #{} --[[
has = in
not = !
#= ]]
local Jl = require("euler/jl")
local any = Jl.any
local filter = Jl.filter
local map = Jl.map
local println = Jl.println
local sum = Jl.sum
local UnitRange = Jl.UnitRange
local function has(t) return function(k) return t[k] end end
local collect = Jl.keys
local function Set(...)
    local result = {}
    for x in ... do result[x] = true end
    return result
end
-- =#

function factors(n)
    return filter(function(x) return n % x == 0 end, UnitRange(1, n // 2))
end

function isabundant(n)
    return sum(factors(n)) > n
end

function euler23()
    abundantnumbers = Set(filter(isabundant, UnitRange(1, 28123)))
    return sum(filter(function(n)
        return not(any(has(abundantnumbers),
            map(function(m)
                return n - m
            end, collect(abundantnumbers))))
    end, UnitRange(1, 28123)))
end

println(euler23())
