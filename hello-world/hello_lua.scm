#!/usr/bin/env -S guile -s
-- code visible to Lua

local function void(...) return void end
local function println(x) print(x) return void end

println "Hello from \x1b[94mLua\x1b[m!"

--[[ code visible to Scheme !#

(define (println x) (display x) (newline))
(println "Hello from \x1b[31mScheme\x1b[m!")

; code visible to Lua and Scheme ]]

(println "Hello from \x1b[94mLua\x1b[m and \x1b[31mScheme\x1b[m!")
