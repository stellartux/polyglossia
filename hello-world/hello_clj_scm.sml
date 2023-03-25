;(* 1 1);
#! code visible to Clojure

(println "Hello from Clojure!")

(comment; code visible to Scheme !#

(define (println x) (display x) (newline))
(println "Hello from Scheme!")

#! code visible to Standard ML *)

fun println s = print s before print "\n";
(println "Hello from Standard ML!");(*

); code visible to Clojure, Scheme and Standard ML !#;*)

(println "Hello from Clojure, Scheme and Standard ML!");
