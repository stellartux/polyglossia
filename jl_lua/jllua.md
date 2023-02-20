# On Julia/Lua Polyglot Programming

The polyglot language of Julia and Lua is quite flexible to program in, as Julia
and Lua start off with very similar syntax. The basic function syntax is
compatible, as well as the usual notation that most languages have for numbers,
strings and booleans.

```julia
function tocelsius(fahrenheit)
    return (fahrenheit - 32) / 9 * 5
end
```

## Escaping

Languages work well together in a polyglot when their syntax as close to the
identical as possible, as long as there is enough different ways of writing
comments that it's possible to write something which is valid code — ideally a
no-op — in one language, and a comment in the other.

Julia and Lua's comment syntaxes don't overlap, Lua uses `--` to begin single
line comments and `--[[` `]]` pairs for multi-line comments, Julia uses `#`
for single line comments and `#=` `=#` pairs for multiline comments. `--` is
an invalid operator in Julia, so Lua comments can't appear anywhere in Julia
code, but fortunately `#` is the `length` operator in Lua, so it's possible to
detect the language by partially commenting out expressions so that they
evaluate to different results.

```lua
islua = #{} and true or
false
```

```julia
islua = #{} and true or
false
```

### Smoothing Out the Differences

This difference is enough to unify a method of printing output in each language.
Julia has `print`/`println` to write to stdout with/without a trailing newline.
The Lua equivalents are `io.write`/`print`. Defining `println` as `print` in
Lua is the simplest way of being able to produce the same output from each
language.

```lua
println = #{} and print or
println

println("Hello from Lua and Julia!")
```

#### ANSI Escape Codes

As a side note, the commonly used ANSI CSI codes for formatting text in the
terminal can be written with hexadecimal escape codes. Lua doesn't understand
`"\e"`, Julia doesn't understand `"\27"`, but both languages understand
`"\x1b"`, so this can be used for more complex terminal control in a language
agnostic way.

```julia
println("\x1b[32mGREAT SUCCESS!\x1b[m")
```

### Escaping Larger Sections

To allow for polyfilling functionality between the languages, it's convenient to
be able to escape a larger section of code. By interleaving single line and
multi-line comments, it's possible to have larger sections which only get
executed as only language or the other.

```lua
_ = #{} --[[ This section is only visible to Julia
println("Hello from Julia!")

#= This section is only visible to Lua ]]
local println = print
println("Hello from Lua!")

-- This section is visible to Julia and Lua =#
println("Hello from Julia and Lua!")
```

