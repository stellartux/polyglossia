(*#=)=() -- Code visible to Haskell

main = do
    putStrLn("Hello from Haskell!")

{- Code visible to Julia =#)

putStrLn = println
putStrLn("Hello from Julia!")

#= Code visible to Standard ML *)

fun putStrLn x = print x before print "\n";
putStrLn "Hello from Standard ML";

(* Code visible to Haskell, Julia and Standard ML =##-}-- *)
    putStrLn("Hello from Haskell, Julia and Standard ML!");
