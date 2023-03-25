(ns Scheme)

(defmacro define [x & xs]
 "Convert a `define` to a `defn` or a `def`"
 (if (list? x)
  (let [name (first x), params (vec (replace '{. &} (rest x)))]
   (cons 'defn (cons name (cons params xs))))
  (cons 'def (cons x xs))))
