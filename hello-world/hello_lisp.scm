#!/usr/bin/env -S guile -e main -s
; code visible to Common Lisp

(defun println (x) (princ x) (terpri))
(println "Hello from Common Lisp!")

#| code visible to Scheme !#

(define (println x) (display x) (newline))
(println "Hello from Scheme!")

; code visible to Common Lisp and Scheme |#
(println "Hello from Common Lisp and Scheme!")
