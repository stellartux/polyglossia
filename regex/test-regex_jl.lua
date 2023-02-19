#!/usr/bin/env lua
Match = #_G and require("regex_jl") --[[
include("regex_jl.lua").match

assert(x, msg="assertion failed!") = if !x error(msg) end
not = !
#=]]
local println = print
local function raw(...) return ... end
--=#

assert(Match("hello", "hello"), "Equal strings should match")

assert(not(Match("world", "hello")), "Unequal strings should not match")

assert(Match("hel*o", "heo"), "* should match 0 times")
assert(Match("hel*o", "helo"), "* should match 1 time")
assert(Match("hel*o", "hello"), "* should match 2 times")

assert(not(Match("hel+o", "heo")), "+ should not match 0 times")
assert(Match("hel+o", "helo"), "+ should match 1 time")
assert(Match("hel+o", "hello"), "+ should match 2 times")

assert(Match("^hello", "hello"), "^ should match the start")
assert(not(Match("^hello", "Xhello")), "^ should not match not the start")

assert(Match(raw"hello$", "hello"), raw"$ should match the end")
assert(not(Match(raw"hello$", "helloX")), raw"$ should not match not the end")

println("All tests passed.")
