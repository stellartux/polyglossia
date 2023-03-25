;(*#=)=(){-
#| Code visible to Ruby
)=0

puts "Hello from Ruby!"

=begin Code visible to Common Lisp |#

(defun puts (x) (princ x) (terpri))
(puts "Hello from Common Lisp!")

#| Code visible to Standard ML *)

fun puts x = print x before print "\n";
puts "Hello from Standard ML!";

(* Code visible to Julia =#)

macro puts_str(s) :(println($s)) end
puts"Hello from Julia!"

#= Code visible to Haskell -}

puts = putStrLn
main = do
    puts "Hello from Haskell!"

{-
=end # Code visible to Common Lisp, Haskell, Julia, Ruby and Standard ML |#;=##-}-- *)

    (puts"Hello from Common Lisp, Haskell, Julia, Ruby and Standard ML!");
