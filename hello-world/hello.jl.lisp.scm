#!/usr/bin/env -S guile -s
#| Code visible to Julia

macro putStrLn_str(s)
    :(println($(s)))
end
putStrLn"Hello from Julia!"

#= Code visible to Common Lisp |#

(defmacro alias (newname oldname)
 `(defmacro ,newname (&rest params) (cons ',oldname params)))

(defmacro define (x &rest y)
 "Scheme style function/variable definitions"
 (if (listp x)
  (cons 'defun (cons (car x) (cons (cdr x) y)))
  (cons 'defvar (cons x y))))

(alias display princ)
(alias newline terpri)

(defun putStrLn (x) (princ x) (terpri))
(putStrLn "Hello from Common Lisp!")

#| code visible to Scheme !#

(define (putStrLn x) (display x) (newline))
(putStrLn "Hello from Scheme!")

#| Code visible to Common Lisp, Julia and Scheme =## |#;|#

(putStrLn"Hello from Common Lisp, Julia and Scheme!")
