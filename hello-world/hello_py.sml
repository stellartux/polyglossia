#" ";(* code visible to Python

puts = print
puts("Hello from \x1b[96mPython\x1b[m!")

''' code visible to Standard ML *)

fun puts x = print x before print "\n";
puts "Hello from Standard ML!";

(* code visible to Python and Standard ML '''#*)

puts("Hello from Python and Standard ML!");
