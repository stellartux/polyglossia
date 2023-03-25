;(* Code visible only to Common Lisp
(defun println (x) (princ x) (princ #\Newline))
(println "Hello from Common Lisp!")

#|| Code visible only to Standard ML *)
fun println x = print x before print "\n";
println "Hello from Standard ML!";

(*||#; Code visible to Common Lisp and Standard ML *)
(println "Hello from Common Lisp and Standard ML!");
