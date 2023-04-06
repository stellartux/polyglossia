local Proquint = require("proquint_jl")

for line in io.lines("testcases.tsv") do
    local str, num = line:match("(%S+)\t(%d+)")
    num = math.tointeger(num)
    assert(Proquint.quint2uint(str) == num, "tonumber(\"" .. str .. "\")")
    assert(Proquint.uint2quint(num) == str, "tostring(" .. num .. ")")
end

print("proquint_jl.lua - All tests passed")
