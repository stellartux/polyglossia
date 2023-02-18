#!/usr/bin/env lua
local _ = #{} --[[
0 # Code visible only to Julia

module EditDistance
export levenshtein

debug = (
    getlocal=(_...) -> isempty(ARGS) && abspath(PROGRAM_FILE) != @__FILE__,
)

pcall(fn, xs...) =
    try
        fn(xs...)
    catch err
        nothing, err.msg
    end

rest(s::AbstractString) = SubString(s, 2)
rest(xs) = xs[2:end]

then = true

#= Code visible only to Lua ]]

local ARGS = arg

local function first(xs)
    if type(xs) == "string" then
        return utf8.codepoint(xs)
    else
        return xs[1]
    end
end

local function length(x)
    if type(x) == "string" then
        return utf8.len(x)
    else
        return #x
    end
end

local min = math.min

local println = print

local function rest(xs)
    if type(xs) == "string" then
        return string.sub(xs, utf8.offset(xs, 2))
    elseif type(xs) == "table" and xs.rest then
        return xs:rest()
    else
        return table.pack(table.unpack(xs, 2))
    end
end

local EditDistance = {}

-- Code visible to Julia and Lua 

--- Calculates the Levenshtein distance between two sequences.
---@generic T
---@param a T[]
---@param b T[]
---@return integer
---@overload fun(a: string, b: string): integer
EditDistance.levenshtein = --[[=#
"Calculates the Levenshtein distance between two sequences."
levenshtein = #]]
function (a, b)
    local lena = length(a)
    local lenb = length(b)
    if lena == 0 then
        return lenb
    elseif lenb == 0 then
        return lena
    elseif first(a) == first(b) then
        return EditDistance.levenshtein(rest(a), rest(b))
    else
        return 1 + min(
            EditDistance.levenshtein(rest(a), b),
            EditDistance.levenshtein(a, rest(b)),
            EditDistance.levenshtein(rest(a), rest(b)))
    end
end

if pcall(debug.getlocal, 4, 1) then
    return EditDistance
elseif length(ARGS) < 2 then
    println("Julia/Lua Polyglot Edit Distances")
    println("Usage: (julia|lua) editdistance_jl.lua word1 word2")
    println("or load the EditDistance module")
    println("   in Julia: include(\"editdistance_jl.lua\")")
    println("   in Lua: EditDistance = require(\"editdistance_jl\")")
else
    println(EditDistance.levenshtein(ARGS[1], ARGS[2]))
end

_ = #{} --[[
0 ; end # ]]
