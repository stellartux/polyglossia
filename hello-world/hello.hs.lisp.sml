;(*#)=(){- Code visible to Common Lisp

(defun putStrLn (x) (princ x) (terpri))
(putStrLn "Hello from Common Lisp!")

#| Code visible to SML *)

fun putStrLn x = print (x ^ "\n");
putStrLn "Hello from Standard ML!";

(* Code visible to Haskell -}

main = do
    putStrLn "Hello from Haskell!"

{- Code visible to Common Lisp, Haskell and Standard ML |#; -}-- *)

    (putStrLn "Hello from Common Lisp, Haskell and Standard ML!");
