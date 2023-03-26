module SML
using Bool, Char, General, List, Option, Real, String, TextIO, Vector
export Bool, Char, General, List, Option, Real, String, TextIO, Vector

# Array :> ARRAY
# ArraySlice :> ARRAY_SLICE
# BinIO :> BIN_IO
# BinPrimIO :> PRIM_IO

module Bool
export andalso, not, orelse

andalso = &&
orelse == ||
not = !

function fromString(s::AbstractString)
    s = strip(s)
    if s == "true"
        Some(true)
    elseif s == "false"
        Some(false)
    end
end

# function scan(getc, strm)

toString = string

end # Bool

# Byte :> BYTE
# CharArray :> MONO_ARRAY
# CharArraySlice :> MONO_ARRAY_SLICE

module Char
export chr, ord

chr = Base.Char
ord = Int

end # Char

# CharVector :> MONO_VECTOR
# CharVectorSlice :> MONO_VECTOR_SLICE

"""
The CommandLine structure provides access to the name and arguments used to
invoke the currently running program. The precise semantics of these operations
are operating system and implementation-specific.
"""
module CommandLine

"The argument list used to invoke the current program."
arguments() = view(ARGS, 2:lastindex(ARGS))

"The name used to invoke the current program."
name() = first(ARGS)

end # CommandLine

# Date :> DATE

module General
export exnMessage, exnName, o

# !
# :=
# before
exnMessage(e::Exception) = typeof(e)
exnName(e::Exception) = e.msg
o = ∘

end # General

# IEEEReal :> IEEE_REAL
# Int :> INTEGER
# IO :> IO
# LargeInt :> INTEGER
# LargeReal :> REAL
# LargeWord :> WORD

module List
# export @
export app, foldl, foldr, hd, length, map, null, rev, tl

# @
app(f::Function) = Base.Fix1(foreach, f)
foldl(f::Function) = (init) -> (l) -> Base.foldl(f, l, init=init)
foldr(f::Function) = (init) -> (l) -> Base.foldr(f, l, init=init)
hd = first
length = Base.length
map(f::Function) = Base.Fix1(Base.map, f)
null = isempty
rev = reverse
tl = Base.tail

last = last
getItem(l) = if !isempty(l) Some((hd(l), tl(l)))
nth(l, i::Integer) = l[firstindex(l) + i]
take = collect ∘ Iterators.take
drop = collect ∘ Iterators.drop
concat = Base.Fix1(reduce, vcat)
revAppend(l1, l2) = [reverse(l1); l2]

"""
Applies `f` to each element `x` of the list `l`, from left to right, until `f x` 
evaluates to `true`. It returns `SOME(x)` if such an `x` exists; otherwise it
returns `NONE`.
"""
find(f::Function) = function(l)
    x = findfirst(f, l)
    if !isnothing(x)
        Some(x)
    end
end

filter(f::Function) = Base.Fix1(Base.filter, f)

# partition

exists(f::Function) = Base.Fix1(Base.any, f)
all(f::Function) = Base.Fix1(Base.all, f)
tabulate(n::Integer, f::Function) = n < 0 ? error("Size") : Base.map(f, 0:n-1)

# collate

end # List

# module ListPair
# end #ListPair
# Math :> MATH

module Option
export getOpt, isSome, valOf

"returns v if opt is SOME(v); otherwise it returns a."
getOpt(x::Some, _) = x.value
getOpt(::Nothing, a) = a

"returns true if opt is SOME(v); otherwise it returns false."
isSome = Base.Fix2(isa, Some)

"returns v if opt is SOME(v); otherwise it raises the Option exception."
valOf(x::Some) = x.value
valOf(_) = throw("Option")

"returns SOME(a) if f(a) is true and NONE otherwise."
filter(f) = (a) -> if f(a); Some(a) end

"The join function maps NONE to NONE and SOME(v) to v."
join(::Nothing) = nothing
join(x::Some{Some}) = x.value

"applies the function f to the value v if opt is SOME(v), and otherwise does nothing."
app(f::Function) = (opt) -> if isSome(opt) f(something(opt)) end

"maps NONE to NONE and SOME(v) to SOME(f v)."
map(f) = (opt) -> Base.map((v) -> if isSome(v) Some(f(s.value)) end, opt) 

"""
maps NONE to NONE and SOME(v) to f(v). 
The expression mapPartial f is equivalent to join o (map f).
"""
mapPartial(f) = (opt) -> Base.map((v) -> if isSome(v) f(s.value) end, opt) 

"""
Returns `NONE` if `g(a)` is `NONE`; otherwise, if `g(a)` is `SOME(v)`, it
returns `SOME(f v)`. Thus, the `compose` function composes `f` with the partial
function `g` to produce another partial function. The expression
`compose (f, g)` is equivalent to `(map f) o g`.
"""
compose(f::Function, g::Function) = map(f) ∘ g

"""
Returns `NONE` if `g(a)` is `NONE`; otherwise, if `g(a)` is `SOME(v)`, it
returns `f(v)`. Thus, the `composePartial` function composes the two partial
functions `f` and `g` to produce another partial function. The expression
`composePartial (f, g)` is equivalent to `(mapPartial f) o g`.
"""
composePartial(f::Function, g::Function) = mapPartial(f) ∘ g

end # Option

# OS :> OS
# Position :> INTEGER

module Real
export ceil, floor, round, trunc

ceil(x::Base.Real) = Base.Int(Base.ceil(x))
floor(x::Base.Real) = Base.Int(Base.floor(x))
fromInt = float
round(x::Base.Real) = Base.Int(Base.round(x))
trunc(x::Base.Real) = Base.Int(Base.trunc(x))

end # Real

# StringCvt :> STRING_CVT

module String
export ^, concat, explode, implode, size, str, substring

^ = Base.:*
concat = join
explode = collect
implode = join
size = length
str = string
substring(s::AbstractString) = (fi::Integer) -> (li::Integer) -> view(s, fi:li)

end # String

# Substring :> SUBSTRING

module TextIO
export print
print = print
end # TextIO

# TextPrimIO :> PRIM_IO
# Text :> TEXT
# Timer :> TIMER
# Time :> TIME
# VectorSlice :> VECTOR_SLICE

module Vector
export vector

vector = collect

end # Vector

# Word8Array :> MONO_ARRAY
# Word8ArraySlice :> MONO_ARRAY_SLICE
# Word8Vector :> MONO_VECTOR
# Word8VectorSlice :> MONO_VECTOR_SLICE
# Word8 :> WORD
# Word :> WORD

real = Real.fromInt

# val ref : 'a -> 'a ref	primitive

end#module
