;; Utilities

(defmacro alias (newname oldname)
 `(defmacro ,newname (&rest params) (cons ',oldname params)))

;; Definitions

(defmacro define (x &rest y)
 "Scheme style function/variable definitions"
 (if (listp x)
  (cons 'defun (cons (car x) (cons (cdr x) y)))
  (cons 'defvar (cons x y))))

(alias display princ)
(alias newline terpri)
