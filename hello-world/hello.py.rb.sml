#" ";(*
''' code visible to Ruby '

puts("Hello from \x1b[91mRuby\x1b[m!")

=begin code visible to Python '''

puts = print
puts("Hello from \x1b[96mPython\x1b[m!")

''' code visible to Standard ML *)

fun puts x = print x before print "\n";
puts "Hello from Standard ML!";

(*
=end # code visible to Python, Ruby and Standard ML '''#*)

puts("Hello from Python, Ruby and Standard ML!");
