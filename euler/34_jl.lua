local Jl = #{} and require("euler/jl") --[[
#=]]
local digits = Jl.digits
local factorial = Jl.factorial
local filter = Jl.filter
local map = Jl.map
local println = Jl.println
local sum = Jl.sum
local UnitRange = Jl.UnitRange
--=#

function euler34()
    return sum(filter(function(n)
        return n == sum(map(factorial, digits(n)))
    end, UnitRange(10, 999999)))
end

println(euler34())
