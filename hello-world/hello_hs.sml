(*#)=0-- Code visible to Haskell

main = do
    putStrLn "Hello from Haskell!"

{- Code visible to Standard ML *)

fun putStrLn x = print x before print "\n";
putStrLn "Hello from Standard ML!";

(* Code visible to Haskell and Standard ML -}-- *)
    putStrLn "Hello from Haskell and Standard ML!";
