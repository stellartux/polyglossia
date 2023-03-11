#!/usr/bin/env -S guile -s
; code visible to Clojure

(println "Hello from Clojure!")

(comment; code visible to Scheme !#

(define (println x) (display x) (newline))
(println "Hello from Scheme!")

#!
); code visible to Clojure and Scheme !#

(println "Hello from Clojure and Scheme!")
