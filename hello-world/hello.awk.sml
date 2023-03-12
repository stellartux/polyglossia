#" ";(* code visible to Awk

function println(s) { print s }
BEGIN {
println("Hello from Awk!")

# code visible to Standard ML

#*)fun println s = print s before print "\n";(*
#*)println "Hello from Standard ML";(*

# code visible to Awk and Standard ML *)

println("Hello from Awk and Standard ML!");

#" ";(*
}#*)
