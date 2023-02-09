#!/usr/bin/env python3
#= Code visible only to Python
println = print
println("Hello from \x1b[36mPython\x1b[m!")

''' Code visible only to Julia =#
println("Hello from \x1b[35mJulia\x1b[m!")

# Code visible to Python and Julia '''
println("Hello from \x1b[36mPython\x1b[m and \x1b[35mJulia\x1b[m!")
