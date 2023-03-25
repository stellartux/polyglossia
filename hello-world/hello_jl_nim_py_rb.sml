#" ";(*
#[
#=
''' code visible to Ruby '

alias echo puts
echo "Hello from Ruby!"

=begin code visible to Python '''

echo = print
echo("Hello from Python!")

''' code visible to Nim ]#

echo "Hello from Nim!"

#[ code visible to Standard ML *)

fun echo s = print s before print "\n";
echo "Hello from Standard ML!";

(* code visible to Julia =#

echo = println
echo("Hello from Julia!")

#=
=end code visible to Julia, Nim, Python, Ruby and Standard ML ]##'''# =##*)

echo("Hello from Julia, Nim, Python, Ruby and Standard ML!");
