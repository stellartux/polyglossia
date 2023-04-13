;; Utilities

(defmacro alias (newname oldname)
 `(defmacro ,newname (&rest params) (cons ',oldname params)))

;; Definitions

(defmacro define (x &rest y)
 "Scheme style function/variable definitions"
 (if (listp x)
  (cons 'defun (cons (car x) (cons (cdr x) y)))
  (cons 'defvar (cons x y))))

;; R5RS

; A
; abs
; acos
(alias angle phase)
; append
; apply
; asin
; atan

; B
(defun boolean? (x) (or (eq x t) (eq x nil)))

; C
; car
; cdr

(defmacro ceiling (&rest body)
 (list 'values (cons 'common-lisp-user::ceiling body)))
(alias ceiling-quotient ceiling)

(defmacro ceiling-remainder (&rest body)
 (list 'nth-value 1 (cons 'common-lisp-user::ceiling body)))

(alias ceiling/ common-lisp-user::ceiling)
(alias char->integer char-code)
(alias char-alphabetic? alpha-char-p)
(alias char-ci<=? char-not-greaterp)
(alias char-ci<? char-lessp)
(alias char-ci=? char-equal)
(alias char-ci>=? char-not-lessp)
(alias char-ci>? char-greaterp)
; char-downcase
(alias char-lower-case? lower-case-p)
(alias char-numeric? digit-char-p)
(alias char-titlecase char-upcase)
(alias char-upper-case? upper-case-p)
(defun char-whitespace? (c)
 (or
  (char= c #\Newline)
  (char= c #\Space)
  (char= c #\Tab)
  (char= c #\Return)))
(alias char<=? char<=)
(alias char<? char<)
(alias char=? char=)
(alias char>=? char>=)
(alias char>? char>)
(alias char? characterp)
(alias complex? complexp)
; cons
; cos
(defmacro current-input-port () *standard-input*)
(defmacro current-output-port () *standard-output*)

; D
(alias display princ)

; E
(alias eq? eq)
(alias equal? equal)
(alias eqv? eql)
; eval
(alias even? evenp)
(alias exact->inexact float)
(alias exact? rationalp)
; exp
; expt

; F
(defvar f nil)
(defmacro floor (&rest body)
 (list 'values (cons 'common-lisp-user::floor body)))
(alias floor-quotient floor)
(defmacro floor-remainder (&rest body)
 (list 'nth-value 1 (cons 'common-lisp-user::floor body)))
(alias floor/ common-lisp-user::floor)
(defmacro for-each (&rest xs)
 (cons 'common-lisp-user::map (cons nil (cons xs))))

; G
; gcd

; I
(alias imag-part imagpart)
(alias inexact->exact rationalize)
(alias inexact? floatp)
(alias input-port? input-stream-p)
(alias integer->char code-char)
(alias integer? integerp)

; L
; lcm
; length
; list
(defmacro list->string (s) `(coerce ,s 'string))
(defmacro list->symbol (s) `(coerce ,s 'symbol))
(defmacro list->vector (l) `(coerce ,l 'vector))
(alias list? listp)
; load
; log

; M
(alias magnitude abs)
(defmacro map (f &rest sequences)
  (cons 'common-lisp-user::map
   (cons ''list ; TODO: get the actual type instead of assuming a list
    ; see http://www.lispworks.com/documentation/HyperSpec/Body/f_map.htm
    (cons (symbol-function f) sequences))))
; max
; member
(defmacro memq (&rest xs) (append (cons 'member xs) '(:test #'eq)))
(defmacro memv (&rest xs) (append (cons 'member xs) '(:test #'eql)))
; min
(alias modulo common-lisp-user::mod)

; N
(alias negative? minusp)
(alias newline terpri)
; not
(alias null? null)
(defmacro number->string (n) `(format nil "~D" ,n))
(alias number? numberp)

; O
(alias odd? oddp)
(defun open-input-file (filename) (open filename :direction :input))
(defun open-output-file (filename) (open filename :direction :output))
(alias output-port? output-stream-p)

; P
(alias pair? consp)
; peek-char
(alias positive? plusp)
(alias procedure? functionp)

; (alias quotient )

; R
(alias rational? rationalp)
; read-char
(alias real-part realpart)
(alias real? realp)
; reverse
(defmacro round (&rest body)
 (list 'values (cons 'common-lisp-user::round body)))
(alias round-quotient round)
(defmacro round-remainder (&rest body)
 (list 'nth-value 1 (cons 'common-lisp-user::round body)))
(alias round/ common-lisp-user::round)

; S
; sin
; sqrt
(defmacro string (&rest cs) `(concatenate 'string ,cs))
(defun string->list (s) `(coerce ,s 'list))
(defun string->number (s) (with-input-from-string (in s) (read in)))
(alias string->symbol make-symbol)
(defun string-append (&rest s) (apply #'concatenate 'string s))
(alias string-length length)
(alias string<=? string-not-greaterp)
(alias string<? string-lessp)
(alias string=? string=)
(alias string>=? string-not-lessp)
(alias string>? string-greaterp)
(alias string? stringp)
(alias substring subseq)
(alias symbol->string string)
(defun symbol-append (&rest xs)
 (concatenate 'string (map 'list #'string xs)))
(alias symbol? symbolp)

; T
; tan
(defmacro truncate (&rest body)
 (list 'values (cons 'common-lisp-user::truncate body)))
(alias truncate-quotient truncate)
(defmacro truncate-remainder (&rest body)
 (list 'nth-value 1 (cons 'common-lisp-user::truncate body)))
(alias truncate/ common-lisp-user::truncate)

; V
; values
; vector
(defmacro vector->list (vec) `(coerce ,vec 'list))
(alias vector-length length)
(alias vector? vectorp)

; Z
(alias zero? zerop)

; Other
(alias char-is-both? both-case-p)
