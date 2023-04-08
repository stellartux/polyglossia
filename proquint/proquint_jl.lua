local _ = #{} --[[
0 # Code visible only to Julia

module Proquint
export quint2uint, uint2quint
begin

local arg = ARGS
local debug = (
    getlocal=(_...) -> isempty(ARGS) && abspath(PROGRAM_FILE) != @__FILE__,
)
local function pcall(fn, xs...)
    try
        fn(xs...)
    catch err
        nothing, err.msg
    end
end
local function peel(s::AbstractString)
    if isempty(s)
        nothing, nothing
    else
        first(s), SubString(s, 2)
    end
end
local strcat = string
local then = true
local function tointeger(n)
    x = parse(Unsigned, n)
    if x <= 0xffffffff
        UInt32(x)
    else
        x
    end
end

uint2quint(i::Signed) = uint2quint((i <= 0xffffffff ? UInt32 : Unsigned)(i))

local uint2consonant = Dict{UInt8,Char}(
    0 => 'b', 1 => 'd',  2=> 'f', 3 => 'g',
    4 => 'h', 5 => 'j', 6 => 'k', 7 => 'l',
    8 => 'm', 9 => 'n', 10 => 'p', 11 => 'r',
    12 => 's', 13 => 't', 14 => 'v', 15 => 'z'
)
local consonant2uint = Dict{Char,UInt8}(
    'b' => 0, 'd' => 1, 'f' => 2, 'g' => 3,
    'h' => 4, 'j' => 5, 'k' => 6, 'l' => 7,
    'm' => 8, 'n' => 9, 'p' => 10, 'r' => 11,
    's' => 12, 't' => 13, 'v' => 14, 'z' => 15
)

local uint2vowel = Dict{UInt8,Char}(0 => 'a', 1 => 'i', 2 => 'o', 3 => 'u')
local vowel2uint = Dict{Char,UInt8}('a' => 0, 'i' => 1, 'o' => 2, 'u' => 3)

#= code visible to Lua ]]

local Proquint = {}

local uint2consonant = {
    [0] = 'b', 'd', 'f', 'g',
    'h', 'j', 'k', 'l',
    'm', 'n', 'p', 'r',
    's', 't', 'v', 'z'
}
local consonant2uint = {
    b = 0, d = 1, f = 2, g = 3,
    h = 4, j = 5, k = 6, l = 7,
    m = 8, n = 9, p = 10, r = 11,
    s = 12, t = 13, v = 14, z = 15,
}

local uint2vowel = { [0] = 'a', 'i', 'o', 'u' }
local vowel2uint = { a = 0, i = 1, o = 2, u = 3 }

local function all(_, xs) return xs:match("^%d+$") end
local function haskey(t, k) return t[k] ~= nil end
local isdigit
local function isnothing(x) return x == nil end
local function last(xs) return xs[#xs] end
local function peel(s) if s ~= "" then return s:sub(1, 1), s:sub(2) end end
local println = print
local function something(x, ...) return x or  something(...) end
local function strcat(s, t, ...) return t and strcat(s .. t, ...) or s end
local tointeger = tonumber

-- code visible to Julia and Lua =#

_=#{}--[[
0;"""

    quint2uint(s::AbstractString)

Map a quint to an integer, skipping non-coding characters.
"""
function quint2uint(s, r::Unsigned = zero(count(isletter, s) > 10 ? UInt64 : UInt32)) #=]]
--- Map a quint to an integer, skipping non-coding characters.
---@param s string
---@return integer
function Proquint.quint2uint(s, r)
    r = r or 0 --=#
    local c, cs = peel(s)
    if isnothing(c) then
        return r
    elseif haskey(consonant2uint, c) then
        return Proquint.quint2uint(cs, (r << 4) | consonant2uint[c])
    elseif haskey(vowel2uint, c) then
        return Proquint.quint2uint(cs, (r << 2) | vowel2uint[c])
    else
        return Proquint.quint2uint(cs, r)
    end
end

_=#{}--[[
function uint2quint(n::UInt16, _ = nothing) #=]]
function Proquint.uint2quint16(n) --=#
    return strcat(
        uint2consonant[0xf & n >> 12],
        uint2vowel[0x3 & n >> 10],
        uint2consonant[0xf & n >> 6],
        uint2vowel[0x3 & n >> 4],
        uint2consonant[0xf & n])
end

local uint2quint16 = #{} and Proquint.uint2quint16 --[[
    uint2quint ∘ UInt16

function uint2quint(n::UInt32, sepchar = '-') #=]]
function Proquint.uint2quint32(n, sepchar)
    sepchar = sepchar or '-' --=#
    return strcat(
        uint2quint16(0xffff & n >> 16),
        sepchar,
        uint2quint16(0xffff & n))
end

_=#{}--[[
function uint2quint(n::UInt64, sepchar = '-') #=]]
function Proquint.uint2quint64(n, sepchar)
    sepchar = sepchar or '-' --=#
    return strcat(
        uint2quint16(0xffff & n >> 48),
        sepchar,
        uint2quint16(0xffff & n >> 32),
        sepchar,
        uint2quint16(0xffff & n >> 16),
        sepchar,
        uint2quint16(0xffff & n))
end

_=#{}--[[
#=]]
--- Map an integer to one to four quints, using `sepchar` to separate them.
---@param n integer
---@param sepchar string? defaults to "-"
---@return string
function Proquint.uint2quint(n, sepchar)
    sepchar = sepchar or '-'
    if n > 0xffffffff then return Proquint.uint2quint64(n, sepchar) end
    return Proquint.uint2quint32(n, sepchar)
end --=#

local function main(x)
    if all(isdigit, x) then
        return Proquint.uint2quint(tointeger(x))
    else
        return Proquint.quint2uint(x)
    end
end

if pcall(debug.getlocal, 4, 1) then
    return Proquint
else
    println(main(last(arg)))
end

_=#{}--[[
0 end end#]]
