#!/usr/bin/env nim
#= code visible to Nim

echo("Hello from \x1b[93mNim\x1b[m!")

#[ code visible to Julia =#

echo = println
echo("Hello from \x1b[35mJulia\x1b[m!")

# code visible to Julia and Nim ]#

echo("Hello from \x1b[35mJulia\x1b[m and \x1b[93mNim\x1b[m!")
