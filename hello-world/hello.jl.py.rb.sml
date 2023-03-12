#" ";(*
#=
''' code visible to Ruby '

alias println puts
println("Hello from \x1b[91mRuby\x1b[m!")

=begin code visible to Python '''

println = print
println("Hello from \x1b[96mPython\x1b[m!")

''' code visible to Julia =#

println("Hello from \x1b[35mJulia\x1b[m!")

#= code visible to Standard ML *)

fun println x = print x before print "\n";
println "Hello from Standard ML!";

(* 
=end # code visible to Julia, Python, Ruby and Standard ML '''# =##*)

println("Hello from Julia, Python, Ruby and Standard ML!");
