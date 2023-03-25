;{- Code visible to Common Lisp

(defun putStrLn (x) (princ x) (princ #\Newline) ())
(defun main ()
  (putstrln "Hello from Common Lisp!")

#| Code visible to Haskell -}

main = do
  putStrLn "Hello from Haskell!"
  (
-- Code visible to Common Lisp and Haskell |#
    (putStrLn "Hello from Common Lisp and Haskell!"))
