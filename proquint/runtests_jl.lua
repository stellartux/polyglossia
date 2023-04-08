_=#{}--[[
  "Julia tests"

using Test
include(joinpath(@__DIR__, "proquint_jl.lua"))
using .Proquint

@testset begin
    for (str, num) in split.(eachline(joinpath(@__DIR__, "testcases.tsv")))
        num = parse(UInt32, num)
        @test quint2uint(str) == num
        @test uint2quint(num) == str
    end
end;

#= Lua tests ]]

local Proquint = require("proquint_jl")

for line in io.lines("testcases.tsv") do
    local str, num = line:match("(%S+)\t(%d+)")
    num = math.tointeger(num)
    assert(Proquint.quint2uint(str) == num, "quint2uint(\"" .. str .. "\")")
    assert(Proquint.uint2quint(num) == str, "uint2quint(" .. num .. ")")
end

print("proquint_jl.lua - All tests passed")

--=#
