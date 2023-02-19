#!/usr/bin/env lua
_=#_G--[[ code here is only visible to Julia

"See https://programmingpraxis.com/2009/09/11/beautiful-code/"
module SimpleRegex

then = true
not = !
struct Postfix{F<:Function} <: Function
    f::F
end
Base.:*(x, p::Postfix) = p.f(x)
and(b) = Postfix((a) -> a && b)
or(b) = Postfix((a) -> a || b)
arg = ARGS
nil = nothing
pcall(f, xs...) =
    try
        f(xs...)
    catch
    end
debug = (
    getlocal=(_...) -> isempty(ARGS) && abspath(PROGRAM_FILE) != @__FILE__,
)
rest(s::AbstractString, dropcount=1) = SubString(s, dropcount + 1)

"""

    match(re::AbstractString, text::AbstractString)

Search for `re` anywhere in `text`. Syntax of `re`:

- `^` matches the start of the text
- `\$` matches the end of the text
- `.` matches any character
- `*` modifies the previous match to match 0 or more times
- `+` modifies the previous match to match 1 or more times
- all other characters match literally
"""
match(::Nothing, _) = true
matchhere(::Nothing, ::Nothing) = true
matchstar(c, re, ::Nothing) = matchstar(c, re, "")

#= code here is only visible to Lua ]]

local SimpleRegex = {}

local Base = {
    splat = function (f)
        return function(x)
            return f(table.unpack(x))
        end
    end
}

local exit = os.exit
local function ifelse(p, c, a) return p and c or a end
local function isempty(xs) return #xs == 0 end
local function get(t, k, d) return t and k and t[k] or d end
local function length(xs) return #xs end

local function occursin(needle, haystack)
    return not not haystack:find(needle, 1, true)
end

local println = print
local function raw(...) return ... end
local function rest(s, i) return s:sub(utf8.offset(s, 1 + (i or 1))) end

getmetatable("").__index = function(s, k)
    local i = math.tointeger(k)
    if i then
        if i < 0 then i = i + #s end
        return s:match(utf8.charpattern, utf8.offset(s, i))
    else
        return string[k]
    end
end

-- code here is visible to Julia and Lua =#

function SimpleRegex.match(re, text)
    if re[1] == '^' then
        return SimpleRegex.matchhere(rest(re), text)
    elseif SimpleRegex.matchhere(re, text) then
        return true
    elseif isempty(text) then
        return false
    else
        return SimpleRegex.match(re, rest(text))
    end
end

function SimpleRegex.matchhere(re, text)
    if isempty(re) then
        return true
    end
    local c = re[1]
    if re == raw"$" then
        return isempty(text)
    elseif isempty(text) then
        return false
    elseif occursin(get(re, 2, '~'), "*+") then
        if (re[2] == '+')and(not(c == text[1])) then
            return false
        end
        return SimpleRegex.matchstar(c, rest(re, 2), text)
    elseif (c == text[1])or(c == '.') then
        return SimpleRegex.matchhere(rest(re), rest(text))
    else
        return false
    end
end

function SimpleRegex.matchstar(c, re, text)
    if SimpleRegex.matchhere(re, text) then
        return true
    elseif isempty(text) then
        return false
    elseif (c == '.')or(c == text[1]) then
        return SimpleRegex.matchstar(c, re, rest(text))
    else
        return false
    end
end

if pcall(debug.getlocal, 4, 1) then
    return SimpleRegex.match
elseif not(length(arg) == 2) then
    println("Usage: (julia|lua) regex_jl.lua PATTERN TEXT")
    exit(2)
else
    exit(ifelse(Base.splat(SimpleRegex.match)(arg), 0, 1))
end

_=#_G--[[
0 end #]]
