;(*#=)=(){- Code visible to Common Lisp

(defun putStrLn (x) (princ x) (terpri))
(putStrLn "Hello from Common Lisp!")

#| Code visible to SML *)

fun putStrLn x = print (x ^ "\n");
putStrLn "Hello from Standard ML!";

(* Code visible to Julia =#)

macro putStrLn_str(s) :(println($s)) end
putStrLn"Hello from Julia!"

#= Code visible to Haskell -}

main = do
    putStrLn "Hello from Haskell!"

{- Code visible to Common Lisp, Haskell, Julia and Standard ML |#;=##-}-- *)

    (putStrLn"Hello from Common Lisp, Haskell, Julia and Standard ML!");
