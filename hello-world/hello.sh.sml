#"_";(* code visible to Shell
# shellcheck shell=sh

echo "Hello from Shell";

: 'code visible to Standard ML' <<=end
*)

fun echo x = print x before print "\n";
echo "Hello from Standard ML!";

(*
=end
# code visible to Shell and Standard ML *)

echo "Hello from Shell and Standard ML!";

