#!/usr/bin/env lua
local _ = #{} --[[
0 # Code visible only to Julia

module EditDistance
export levenshtein

cache(height, width) = Array{Union{Missing,Int}}(missing, height, width)

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

setindex = setindex!

then = true
begin

#= Code visible only to Lua ]]

local ARGS = arg

local function first(xs)
    if type(xs) == "string" then
        return utf8.codepoint(xs)
    else
        return xs[1]
    end
end

local function getindex(xs, i, ...)
    if i then
        return getindex(xs[i], ...)
    else
        return xs
    end
end

local function ismissing(x) return x == nil end

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

local function setindex(xs, v, j, i, ...)
    if i then
        setindex(xs[j], v, i, ...)
    else
        xs[j] = v
    end
end

local function cache(height, _)
    local result = {}
    while height > 0 do
        table.insert(result, {})
        height = height - 1
    end
    return result
end

local EditDistance = {}

-- Code visible to Julia and Lua =#

local function lev(a, b, c)
    local lena = length(a)
    local lenb = length(b)
    if lena == 0 then
        return lenb
    elseif lenb == 0 then
        return lena
    elseif ismissing(getindex(c, lena, lenb)) then
        local ld = lev(rest(a), rest(b), c)
        if first(a) == first(b) then
            setindex(c, ld, lena, lenb)
        else
            setindex(c,
                1 + min(
                    ld,
                    lev(rest(a), b, c),
                    lev(a, rest(b), c)),
                lena, lenb)
        end
    end
    return getindex(c, lena, lenb)
end

_ = #{} --[[
0;"Calculates the Levenshtein distance between two sequences."
function levenshtein(a, b) #= ]]
--- Calculates the Levenshtein distance between two sequences.
---@generic T
---@param a T[]
---@param b T[]
---@return integer
---@overload fun(a: string, b: string): integer
function EditDistance.levenshtein(a, b) --=#
    return lev(a, b, cache(length(a), length(b)))
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
0 end end#]]
