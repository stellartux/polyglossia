#!/usr/bin/env lua
(#{} and ""):byte() --[[
""" Code visible only to Lua ]]

println = print
println("Hello from \x1b[94mLua\x1b[m!")

--[[ Code visible only to Python """)#=

println = print
println("Hello from \x1b[36mPython\x1b[m!")

""" Code visible only to Julia =#

println("Hello from \x1b[35mJulia\x1b[m!")

# Code visible to Julia, Lua and Python """#]]

println("Hello from \x1b[35mJulia\x1b[m, \x1b[94mLua\x1b[m and \x1b[36mPython\x1b[m!")
