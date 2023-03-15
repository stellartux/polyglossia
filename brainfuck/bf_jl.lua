#!/usr/bin/env lua

local Brainfuck = #_G and {} --[[
nothing # Code here is only visible to Julia

module Brainfuck
begin
then = true
not = !
table = (remove = (t, _...) -> popfirst!(t),)
pcall(f, xs...) =
    try
        f(xs...)
    catch
    end
debug = (
    getlocal=(_...) -> isempty(ARGS) && abspath(PROGRAM_FILE) != @__FILE__,
)

#= Code here is only visible to Lua ]]

local ARGS = arg
local Char = string.char
local UInt8 = string.byte

local function collect(s)
    if type(s) == "string" then
        local cs = {}
        for c in s:gmatch(".") do
            table.insert(cs, c)
        end
        return cs
    else
        return s
    end
end

local function filter(fn, s)
    local chars = {}
    for c in s:gmatch(".") do
        if fn(c) then
            table.insert(chars, c)
        end
    end
    return chars
end

local function foreach(fn, xs) for _,v in ipairs(xs) do fn(v) end end
local function get(xs, k, d) return k and xs[k] or d end
local function isempty(xs) return #xs == 0 end
local function lastindex(xs) return #xs end

local function occursin(s, ss)
    if ss then
        return ss:find(s, 1, true)
    else
        return function(c)
            return s:find(c, 1, true)
        end
    end
end

local println = print
local print = io.write

local function readchomp(filename)
    local f = assert(io.open(filename))
    local s = f:read("a")
    f:close()
    return s
end

local readline = io.read
local function sign(x) return x > 0 and 1 or x < 0 and -1 or 0 end
local function Vector(_) return function() return {} end end

local function zeros(_, _)
    return setmetatable({}, { __index = function(...) return 0 end })
end

-- Code here is visible to Lua and Julia =#

local cs = Vector{Char}()
local function getchar()
    if isempty(cs) then
        cs = collect(readline())
    end
    return table.remove(cs, 1)
end

local function findbracket(code, ip, dir)
    local c = code[ip]
    if c == '[' then
        dir = dir + 1
    elseif c == ']' then
        dir = dir - 1
    end
    if dir == 0 then
        return ip
    else
        return findbracket(code, ip + sign(dir), dir)
    end
end

local function interpret(mem, mp, code, ip)
    if ip > lastindex(code) then
        return
    end
    local c = code[ip]
    if c == '.' then
        print(Char(mem[mp]))
    elseif c == ',' then
        mem[mp] = UInt8(getchar())
    elseif c == '<' then
        mp = mp - 1
    elseif c == '>' then
        mp = mp + 1
    elseif c == '+' then
        mem[mp] = (mem[mp] + 0x01) & 0xff
    elseif c == '-' then
        mem[mp] = (mem[mp] - 0x01) & 0xff
    elseif c == '[' then
        if mem[mp] == 0 then
            ip = findbracket(code, ip, 0)
        end
    elseif c == ']' then
        if (not(mem[mp] == 0))then
            ip = findbracket(code, ip, 0)
        end
    end
    return interpret(mem, mp, code, ip + 1)
end

_=#_G; Brainfuck.run = --[[
0; "Executes the given brainfuck program."
run = #]]
function (code)
    interpret(zeros(UInt8, 30000), 1, filter(occursin("+-,.[]<>"), code), 1)
end

_=#_G; Brainfuck.runfile = --[[
0; "Loads and runs the brainfuck file with the given filename."
runfile = #]]
function (filename) Brainfuck.run(readchomp(filename)) end

if pcall(debug.getlocal, 4, 1) then
    return Brainfuck
elseif get(ARGS, 1, "--help") == "--help" then
    println("Julia/Lua Polyglot Brainfuck Interpreter")
    println("Usage: (julia|lua) bf_jl.lua FILENAMES...")
    println("or load the Brainfuck module")
    println("\tin Julia: include(\"bf_jl.lua\")")
    println("\tin Lua: Brainfuck = require(\"bf_jl\")")
else
    foreach(Brainfuck.runfile, ARGS)
end

_=#_G--[[
0 end end # module ]]
