using Test
include(joinpath(@__DIR__, "proquint_jl.lua"))
using .Proquint

@testset begin
    for (str, num) in split.(eachline(joinpath(@__DIR__, "testcases.tsv")))
        num = parse(UInt, num)
        @test quint2uint(str) == num
        @test uint2quint(num) == str
    end
end;
