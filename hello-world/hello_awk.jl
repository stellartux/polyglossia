#!/usr/bin/awk
#= code visible to Awk

function println(s) { print s }
BEGIN {
    println("Hello from \x1b[30mAwk\x1b[m!")

# code visible to Julia

# =#println("Hello from \x1b[35mJulia\x1b[m!")

# code visible to Awk and Julia

    println("Hello from \x1b[30mAwk\x1b[m and \x1b[35mJulia\x1b[m!") 

#=
}# =#
