"""

    Lua

The Lua module exports various implementations of Lua language and library
features to allow for easier polyglot programming in Lua and Julia.
"""
module Lua

"Make a closure postfix."
struct Postfix{F<:Function} <: Function
    f::F
end
(p::Postfix)(args...; kwargs...) = p.f(args...; kwargs...)
Base.:*(::Tuple{}, p::Postfix) = p.f()
Base.:*(x, p::Postfix) = p.f(x)
Base.:*(x::Tuple, p::Postfix) = p.f(x...)

then(b::Bool) = b
then(::Nothing) = false
then(_) = true
Base.:*(x, ::typeof(then)) = then(x)
Base.:*(x::Tuple, ::typeof(then)) = then(first(x))

not(b::Bool) = !b
not(::Nothing) = true
not(::Tuple{}) = false
not(::Tuple) = not(first(tuple))

"""

    (a)and(b)

Julia `and` does not short circuit, both sides are evaluated before the `and`.
"""
and(b) = Postfix((a) -> a * then ? b : a)

"""

    (a)or(b)

Julia `or` does not short circuit, both sides are evaluated before the `or`.
"""
or(b) = Postfix((a) -> a * then ? a : b)

arg = ARGS
nil = nothing

mutable struct Table
    dict::Dict{Any,Any}
    vec::Vector{Any}
    mt::Union{Table,Nothing}
end
Table(xs::Vector; mt=nothing) = Table(Dict(), xs, mt)
Table(kv::Dict=Dict(); mt=nothing) = Table(kv, [], mt)

hasmetamethod(t::Table, mm) = mm in keys(getmetatable(t))

function Base.getproperty(t::Table, key::Symbol)
    val = get(getfield(t, :dict), string(key), nothing)
    if !isnothing(val)
        val
    else
        mt = getmetatable(t)
        if !isnothing(mt)
            index = rawget(mt, "__index")
            if index isa Table
                getproperty(index, key)
            elseif index isa Function
                index(t, key)
            end
        end
    end
end

function Base.getindex(t::Table, key)
    val = rawget(t, key)
    if isnothing(val)
        mt = getmetatable(t)
        if !isnothing(mt)
            index = rawget(mt, :__index)
            if index isa Table
                index[k]
            elseif index isa Function
                index(t, k)
            end
        end
    else
        val
    end
end

function Base.setindex!(t::Table, value, key)::Nothing
    rawset(t, value, key)
    nothing
end

function Base.length(t::Table)
    if hasmetamethod(t, :__len)
        callmetamethod(t, :__len)
    else
        rawlen(t)
    end
end

Base.firstindex(::Table) = 1
Base.lastindex(t::Table) = lastindex(getfield(t, :vec))

assert(v::Bool, msg::AbstractString, _...) = v ? v : error(msg)
assert(::Nothing, msg::AbstractString, _...) = error(msg)
assert(::Nothing, _...) = error("assertion failed!")
assert(xs...) = xs
function assert(t::Tuple)
    if isempty(t) || first(t) == false || isnothing(first(t))
        error(get(t, 2, "assertion failed!"))
    end
    t
end
function assert(t::Tuple, msg::AbstractString)
    if isempty(t) || first(t) == false || isnothing(first(t))
        error(msg)
    end
    t
end

function collectgarbage(opt::AbstractString="collect", _...)
    if opt == "collect"
        GC.gc()
    elseif opt == "stop"
        GC.enable(false)
    elseif opt == "restart"
        GC.enable(true)
    elseif opt == "step"
        GC.gc(false)
    elseif opt in ("count", "isrunning", "incremental", "generational")
        @warn "Doing nothing about collectgarbage($(repr(opt)))"
    else
        throw("Unrecognised option: " * opt)
    end
end

error(message::AbstractString, _::Integer=1) = throw(message)

_G = Lua

getmetatable(t::Table) = getfield(t, :mt)
getmetatable(::AbstractString) = Lua.string
getmetatable(_) = nothing

setmetatable(t::Table, mt) = setfield!(t, :mt, mt)

ipairs(t::Table) = pairs(getfield(t, :vec))
ipairs(xs) = enumerate(xs)
Base.pairs(t::Table) = Iterators.flatten((ipairs(t), pairs(getfield(t, :dict))))

function pcall(f, xs...)
    try
        f(xs)
    catch err
        nothing, err.msg
    end
end

print = println

rawequal = ===

function rawget(t::Table, key::Integer)
    vec = getfield(t, :vec)
    key in keys(vec) ? vec[key] : get(getfield(t, :dict), key, nothing)
end
rawget(::Table, ::Nothing) = nothing
rawget(t::Table, key) = get(getfield(t, :dict), key, nothing)
rawget(t, k) = t[k]

rawlen(s::AbstractString) = ncodeunits(s)
rawlen(t::Table) = length(getfield(t, :vec))

function rawset(t::Table, value, key::Integer)::Nothing
    vec = getfield(t, :vec)
    dict = getfield(t, :dict)
    if key in keys(vec)
        vec[key] = value
    elseif key == lastindex(vec) + 1
        push!(vec, value)
        while lastindex(vec) + 1 in keys(dict)
            push!(vec, pop!(dict, lastindex(vec) + 1))
        end
    else
        push!(dict, k => v)
    end
    nothing
end

function rawset(t::Table, ::Nothing, key::Integer)::Nothing
    vec = getfield(t, :vec)
    dict = getfield(t, :dict)
    if key in keys(vec)
        while lastindex(vec) > key
            push!(dict, lastindex(vec) => pop!(vec))
        end
        pop!(vec)
    else
        delete!(dict, key)
    end
    nothing
end

function rawset(t::Table, value, key)::Nothing
    getfield(t, :dict)[key] = value
    nothing
end

function rawset(t::Table, ::Nothing, key)::Nothing
    delete!(getfield(t, :dict), key)
    nothing
end

function select(index::AbstractString, xs::Vararg)
    assert(index == "#", "bad argument #1 to 'select' (number expected, got string)")
    length(xs)
end
select(index::Integer, xs::Vararg) = xs[index]

tonumber(e::Number, _=10) = e
tonumber(e::AbstractString, base::Integer=10) = parse(Number, e; base=base)
tonumber(_, _=nothing) = nothing

tostring = string

type(::AbstractString) = "string"
type(::Bool) = "boolean"
type(::Function) = "function"
type(::Nothing) = "nil"
type(::Number) = "number"
type(v) = "table"

const _VERSION = "Lua 5.4"

let warnings_active = false
    global warn(msgs::Vararg{String}) = warn(join(msgs))
    global function warn(msg::AbstractString)
        if msg == "@on"
            warnings_active = true
        elseif msg == "@off"
            warnings_active = false
        elseif warnings_active
            println("Lua warning: ", msg)
        end
    end
end

"This function is similar to pcall, except that it sets a new message handler msgh."
xpcall = pcall

module math
using Random: seed!

const huge = Inf
const maxinteger = typemax(Int)
const mininteger = typemin(Int)

export pi, abs, acos, asin, atan, ceil, cos, exp, floor, log, max, min, sin,
    sqrt, tan

deg = deg2rad
fmod = rem

modf(x::Number) = fldmod(x, one(x))

rad = rad2deg

random() = rand()
random(m::Integer) = rand(1:m)
random(m::Integer, n::Integer) = rand(m:n)

randomseed(x::Integer, y::Integer) = seed!(x | y << 32)
randomseed(x::Integer) = seed!(x)
randomseed() = seed!()

tointeger(x::Integer) = x
tointeger(s::AbstractString) = parse(Int, s)
tointeger(_) = nothing

type(x::Integer) = "integer"
type(x::Number) = "float"
type(_) = nothing

ult(m::Signed, n::Signed) = (m >= 0) == (n >= 0) ? m < n : m >= 0
ult(m::Unsigned, n::Unsigned) = m < n

end # math

module os
using Dates

date() = Dates.format(dateformat"e u d HH:MM:SS Y", now())
function date(format, time = startswith(format, '!') ? now(Dates.UTC) : now())
    if startswith(format, '!')
        format = SubString(format, 2)
    end
    if format == "*t"
        (
            year = Dates.year(time),
            month = Dates.month(time),
            day = Dates.day(time),
            hour = Dates.hour(time),
            min = Dates.minute(time),
            sec = Dates.second(time),
            wday = mod1(Dates.dayofweek(time) + 1, 7),
            yday = Dates.dayofyear(time),
            isdst = nothing
        )
    else
        Dates.format(time, format)
    end
end

difftime(t2::Integer, t1::Integer) = t1 - t2

execute() = true
function execute(cmd::AbstractString)
    try
        true, "exit", run(Cmd([cmd])).exitcode
    catch err
        false, "exit", err.procs[1].exitcode
    end
end

exit(code::Bool=true, _::Bool=false) = Base.exit(code ? 0 : 1)
exit(code::Integer, _::Bool=false) = Base.exit(code)

getenv(varname::AbstractString) = get(ENV, varname, nothing)

function remove(filename)
    try
        rm(filename)
    catch err
        (nothing, err.msg)
    end
end

function rename(oldname, newname)
    try
        mv(oldname, newname)
        true
    catch err
        (nothing, err.msg)
    end
end

time(date...) = Int(floor(Base.time(date)))

tmpname = tempname

end # os

module string
using Printf

byte(s::AbstractString, i::Integer=1) = codeunit(s, i)
byte(s::AbstractString, i::Integer, j::Integer) =
    Tuple(codeunit(s, k) for k in i:j)

char(bytes::Vararg{Integer}) = join(Char(c) for byte in bytes)

function find(s::AbstractString, pattern::AbstractString, init::Integer=1, plain::Bool=false)
    if plain
        m = findnext(pattern, s, init)
        return m ? first(m), last(m) : nothing
    end
    m = Base.match(Regex(pattern), s, init)
    if m
        tuple(m.offset, m.offset + length(m.match) - 1, m.captures...)
    end
end

format(s::AbstractString, xs...) = Printf.format(Printf.Format(s), xs...)


len = ncodeunits

lower = lowercase

rep(s::AbstractString, n::Integer) = repeat(s, n)
rep(s::AbstractString, n::Integer, sep) = join(Iterators.repeated(s, n), sep)

export reverse

sub(s::AbstractString, i::Integer, j::Integer=lastindex(s)) = view(s, i:j)


upper = uppercase

end # string

module table

concat(list, sep::AbstractString="") = join(list, sep)
concat(list, sep::AbstractString, i::Integer, j::Integer=lastindex(list)) =
    join(view(list, i:j), sep)

insert(list, pos::Integer, ::Nothing) = push!(list, pos)
insert(list, value, _::Nothing=nothing) = push!(list, value)
insert(list, pos::Integer, value) = insert!(list, pos, value)

"""
Moves elements from the table a1 to the table a2, performing the equivalent to
the following multiple assignment: a2[t],··· = a1[f],···,a1[e]. The default for
a2 is a1. The destination range can overlap with the source range. The number of
elements to be moved must fit in a Lua integer.

Returns the destination table a2.
"""
function move(a1::Table, f::Integer, e::Integer, t::Integer, a2::Table=a1)
    a2[t:(t+e-f)] .= a1[f:e]
    a2
end

pack(xs...) = Table([xs...])

remove(list) = pop!(list)
remove(list, pos::Integer) = splice!(list, pos)

sort(list, comp) = sort!(list, lt=comp)

function unpack(list::Table, i::Integer=1, j::Integer=lastindex(list))
    i == j ? list[i] : Tuple(getfield(list, :vec)[i:j])
end

end # table

"https://www.lua.org/manual/5.4/manual.html#pdf-utf8"
module utf8

char(codes::Vararg{Integer}) = join(Char.(codes))

const charpattern = r"(?:[\0-\x7F]|[\xC2-\xFD][\x80-\xBF]+)"

codes(s::AbstractString, _::Bool=false) = (k => Int(v) for (k, v) in pairs(s))

function codepoint(s::AbstractString, i::Integer=1, j::Integer=i, _::Bool=false)
    Tuple(Int(c) for c in SubString(s, i, j))
end

function len(s::AbstractString, i::Integer=1, j::Integer=1, _=false)
    ss = view(s, i:j)
    if isvalid(ss)
        ncodeunits(ss)
    else
        Vararg(nothing, findfirst(!isvalid, ss))
    end
end

function offset(s, n, i = n >= 0 ? 1 : ncodeunits(s) + 1) 
    if iszero(n)
        return checkbounds(Bool, s, i) ? thisind(s, i) : nothing
    end
    if checkbounds(Bool, s, i + n)
        t = iterate(Iterators.drop(keys(s), n - 1))
        if !isnothing(t)
            first(t)
        elseif n == length(s) + 1
            ncodeunits(s) + 1
        end
    end
end

end # utf8
end # Lua
