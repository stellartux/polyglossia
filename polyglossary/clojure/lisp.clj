(ns CommonLisp)

(defmacro defun [name params & body]
 "Convert a `defun` to a `defn`"
 (cons 'defn (cons name (cons (vec (replace '{&rest &} params)) body))))
