;/* code visible to Common Lisp

(defun println (s) (princ s) (terpri))
(println "Hello from Common Lisp!")
(defun msg () "Hello from Common Lisp and JavaScript!")

#| code visible to JavaScript */

var println;
if (this == undefined) {
  println = console.log;
  println("Hello from \x1b[33mdeno\x1b[m!");
} else if (this.print) {
  println = print;
  println("Hello from \x1b[33mqjs\x1b[m!");
} else if (this.display) {
  this.console = { log: println = function(s) { display(s); newline(); }};
  println("Hello from \x1b[33mguile\x1b[m!");
} else {
  println = console.log;
  println("Hello from \x1b[33mnode\x1b[m!");
}
var msg = "Hello from Common Lisp and JavaScript!";

// code visible to Common Lisp and JavaScript |#

(println (msg));
