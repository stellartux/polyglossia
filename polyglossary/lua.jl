"""

    Lua

The Lua module exports various implementations of Lua language and library
features to allow for easier polyglot programming in Lua and Julia.
"""
module Lua

then(b::Bool) = b
then(::Nothing) = false
then(_) = true
Base.:*(x, ::typeof(then)) = then(x)
Base.:*(x::Tuple{}, ::typeof(then)) = false
Base.:*(x::Tuple, ::typeof(then)) = then(first(x))

not(b::Bool) = !b
not(::Nothing) = true
not(::Tuple{}) = false
not(::Tuple) = not(first(tuple))
not(::Any) = false

"""

    (a)and(b)

Julia `and` does not short circuit, both sides are evaluated before the `and`.
"""
and(a, b) = then(a) ? b : a
and(::Tuple{}, _) = nothing
and(a::Tuple, b) = and(first(a), b)
and(b) = Base.Fix2(and, b)
and(::Tuple{}) = and(nothing)
and(t::Tuple) = and(first(t))

"""

    (a)or(b)

Julia `or` does not short circuit, both sides are evaluated before the `or`.
"""
or(a, b) = then(a) ? a : b
or(b) = Base.Fix2(or, b)
or(::Tuple{}, b) = b
or(a::Tuple, b) = or(first(a), b)
or(b) = Base.Fix2(or, b)
or(::Tuple{}) = or(nothing)
or(t::Tuple) = or(first(t))

Base.:*(b, f::Base.Fix2{Union{typeof(and),typeof(or)},<:Any}) = f(b)
Base.:*(::Tuple{}, f::Base.Fix2{Union{typeof(and),typeof(or)},<:Any}) = f(nothing)
Base.:*(b::Tuple, f::Base.Fix2{Union{typeof(and),typeof(or)},<:Any}) = f(first(b))

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

function next(t::Table, index::Integer)
    vec = getfield(t, :vec)
    dict = getfield(t, :dict)
    if index in keys(vec)
        reverse(iterate(vec, index))
    else
        iterate(dict)
    end
end

# some sort of weakdict mapping table and keys to iteration states?

next(t::Table, key) = iterate(t, key)

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

function select(index::Union{AbstractChar,AbstractString}, xs::Vararg)
    assert(string(index) == "#",
        "bad argument #1 to 'select' (number expected, got string)")
    length(xs)
end
select(index::Integer, xs::Vararg) = xs[index]

tonumber(e::Number, _=10) = e
tonumber(e::AbstractString, base::Integer=10) = parse(Number, e; base=base)
tonumber(_, _=nothing) = nothing

tostring = string

type(::Union{AbstractChar,AbstractString}) = "string"
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

# module coroutine

# Coroutine = Channel

# function create(f::Function) end

# function isyieldable(co::Coroutine) end
# function isyieldable() end
# function close(co::Coroutine) end

# function resume(co::Coroutine, vals...) end

# function running() end

# function status(co::Coroutine) end

# function wrap(f) end

# function yield(...) end

# end # coroutine

module io
export stdin, stdout, stderr

begin
    local defaultin = stdin
    local defaultout = stdout

    function close(file=defaultout)
        if file != stdout
            Base.close(file)
            true
        end
        false
    end

    flush(file=defaultout) = Base.flush(file)

    input(file) = defaultin = file
    input(path::AbstractString) = input(Base.open(path))
    input() = defaultin

    lines(file=defaultin) = eachline(file)
    lines(file, mode::AbstractString) = lines(file, only(mode))
    function lines(file, mode::AbstractChar)
        # todo: return Lua-style iterator function over Julia iterator
        if mode == 'a'
            Base.read(file, String)
        elseif mode == 'n'
            @warn "unimplemented lines(..., 'n')"
            # todo: parse whole file as numbers
        elseif mode == 'l' || mode == 'L'
            eachline(file, keep=mode == 'L')
        else

        end
    end

    output() = defaultout
    output(file) = (io.defaultout = file)
    output(filename::AbstractString) = output(open(filename, "w"))

    read(fmt...) = Base.read(defaultin, fmt...)
    read(io::IO, fmt...) = Base.read(io, fmt...)

    function write(file::IO, xs...)
        try
            Base.print(file, xs...)
            file
        catch err
            nothing, err.msg
        end
    end
    write(xs...) = write(defaultout, xs...)

end # defaultfile scope

open(prog::AbstractString, mode::AbstractChar) = open(prog, string(mode))
function open(filename::AbstractString, mode::AbstractString="r")
    try
        Base.open(filename, replace(mode, 'a'=>'w', 'b'=>""))
    catch err
        nothing, err.msg
    end
end

popen(prog::AbstractString, mode::AbstractString) = popen(prog, first(mode))
function popen(prog::AbstractString, mode::AbstractChar='r')
    try
        buf = IOBuffer()
        if mode == 'r'
            run(pipeline(Cmd([prog]), buf))
            seekstart(buf)
            buf
        elseif mode == 'w'
            # todo: a wrapper with a file-like interface which buffers writes
            # then executes the command on read/finalize
            error("Unimplemented")
        else
            ArgumentError("bad argument #2 to 'popen' (invalid mode)")
        end
    catch err
        nothing, err.msg
    end
end

# return file* (possibly wrap this type)
tmpfile() = Base.open(tempname(), "w+")

type(file::IO) = isopen(file) ? "file" : "closed file"
type(_) = nothing

struct filep <: IO
    mode
end

#@alias readmode integer|string
#| "n"  # ##DESTAIL 'readmode.n'
#| "a"  # ##DESTAIL 'readmode.a'
#|>"l"  # ##DESTAIL 'readmode.l'
#| "L"  # ##DESTAIL 'readmode.L'

#@alias exitcode "exit"|"signal"

##DES 'file:close'
#@return boolean?  suc
#@return exitcode? exitcode
#@return integer?  code
# function file:close() end

##DES 'file:flush'
# function file:flush() end

##DES 'file:lines'
#@param ... readmode
#@return fun():any, ...
# function file:lines(...) end

##DES 'file:read'
#@param ... readmode
#@return any
#@return any ...
#@nodiscard
# function file:read(...) end

#@alias seekwhence
#| "set" # ##DESTAIL 'seekwhence.set'
#|>"cur" # ##DESTAIL 'seekwhence.cur'
#| "end" # ##DESTAIL 'seekwhence.end'

##DES 'file:seek'
#@param whence? seekwhence
#@param offset? integer
#@return integer offset
#@return string? errmsg
# function file:seek(whence, offset) end

#@alias vbuf
#| "no"   # ##DESTAIL 'vbuf.no'
#| "full" # ##DESTAIL 'vbuf.full'
#| "line" # ##DESTAIL 'vbuf.line'

##DES 'file:setvbuf'
#@param mode vbuf
#@param size? integer
# function file:setvbuf(mode, size) end

##DES 'file:write'
#@param ... string|number
#@return file*?
#@return string? errmsg
# function file:write(...) end

end # io

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
function date(format, time=startswith(format, '!') ? now(Dates.UTC) : now())
    if startswith(format, '!')
        format = SubString(format, 2)
    end
    if format == "*t"
        (
            year=Dates.year(time),
            month=Dates.month(time),
            day=Dates.day(time),
            hour=Dates.hour(time),
            min=Dates.minute(time),
            sec=Dates.second(time),
            wday=mod1(Dates.dayofweek(time) + 1, 7),
            yday=Dates.dayofyear(time),
            isdst=nothing
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

function remove(filename::AbstractString)
    try
        rm(filename)
    catch err
        (nothing, err.msg)
    end
end

function rename(oldname::AbstractString, newname::AbstractString)
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
        return m ? (first(m), last(m)) : nothing
    end
    find(s, LuaPattern(pattern), init)
end

function find(s::AbstractString, pattern::AbstractPattern, init::Integer=1)
    m = Base.match(pattern, s, init)
    if !isnothing(m)
        tuple(m.offset, m.offset + length(m.match) - 1, m.captures...)
    end
end

format(s::AbstractString, xs...) = Printf.format(Printf.Format(s), xs...)

mutable struct Gmatch{S<:AbstractString,P<:AbstractPattern} <: Function
    s::S
    pattern::P
    i::Int
end

function (g::Gmatch)()
    x = iterate(g)
    if !isnothing(x)
        last(x)
    end
end

function Base.iterate(g, _=nothing)
    m = Base.match(g.pattern, g.s, g.i)
    if isnothing(m)
        g.i = lastindex(g.s) + 1
        nothing
    else
        g.i = nextind(g.s, m.offset + length(m.match) - 1)
        r = if isempty(m.captures)
            m.match
        elseif isone(length(m.captures))
            only(m.captures)
        else
            Tuple(m.captures)
        end
        r, r
    end
end

Base.eltype(::Gmatch) = Union{AbstractString,Tuple{Vararg{AbstractString}}}
Base.isdone(g::Gmatch) = g.i > lastindex(g.s)
Base.IteratorSize(::Gmatch) = Base.SizeUnknown()

gmatch(s::AbstractString, pattern::AbstractPattern, init=1) =
    Gmatch(s, pattern, init)

##DES 'gsub'
#@param s       string
#@param pattern string
#@param repl    string|number|table|function
#@param n?      integer
#@return string
#@return integer count
#@nodiscard
function gsub(s::AbstractString, pattern::AbstractPattern, repl::Function, n::Integer=-1)
    inds = findall(pattern, s)
    if isempty(inds)
        return s, 0
    end
    ending = SubString(s, nextind(s, last(last(inds))))
    result = [SubString(s, firstindex(s), first(first(inds)) - 1)]
    replacements = 0
    while n != replacements && !isempty(inds)
        push!(result, repl(view(s, popfirst!(inds))))
        replacements += 1
    end
    if !isempty(inds)
        ending = SubString(s, nextind(s, last(first(inds))))
    end
    push!(result, ending)
    join(result), replacements
end
gsub(s, pattern, repl::Number, xs...) =
    gsub(s, pattern, Returns(string(repl)), xs...)
gsub(s, pattern, repl::AbstractString, xs...) =
    gsub(s, pattern, Returns(repl), xs...)
gsub(s, pattern, repl::Table, xs...) =
    gsub(s, pattern, (key) -> string(get(repl, key, "")), xs...)
gsub(s::AbstractString, pattern::AbstractString, repl::Function, xs...) =
    gsub(s, LuaPattern(pattern), repl, xs...)

len = ncodeunits

lower = lowercase

match(s::AbstractString, pattern::AbstractString, init::Integer=1) =
    match(s, LuaPattern(pattern), init)

function match(s::AbstractString, pattern::AbstractPattern, init::Integer=1)
    m = Base.match(pattern, s, init)
    if !isnothing(m)
        if isempty(m.captures)
            m.match
        elseif isone(length(m.captures))
            only(m.captures)
        else
            Tuple(m.captures)
        end
    end
end

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
concat(t::Table, xs...) = concat(getfield(t, :vec), xs...)

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

function offset(s, n, i=n >= 0 ? 1 : ncodeunits(s) + 1)
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
