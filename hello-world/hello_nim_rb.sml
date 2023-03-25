#" ";(*
#[ code visible to Ruby

alias echo puts
echo "Hello from Ruby!"

=begin code visible to Nim ]#

echo "Hello from Nim!"

#[ code visible to Standard ML *)

fun echo s = print s before print "\n";
echo "Hello from Standard ML!";

(*
=end code visible to Nim, Ruby and Standard ML ]##*)

echo "Hello from Nim, Ruby and Standard ML!";
