#!/usr/bin/env swipl
/*/* Code visible to JavaScript */

var println;
if (this == undefined) {
  println = console.log;
  println("Hello from \x1b[33mdeno\x1b[m!");
} else if (this.print) {
  println = print;
  println("Hello from \x1b[33mqjs\x1b[m!");
} else {
  println = console.log;
  println("Hello from \x1b[33mnode\x1b[m!");
}

;` Code visible to Prolog */

println(S) :- format("~s\n", [S]).

:- println("Hello from \x1b[38:5:202mProlog\x1b[0m").

:- % code visible to JavaScript and Prolog `

println("Hello from \x1b[33mJavaScript\x1b[0m and \x1b[38:5:202mProlog\x1b[0m!")

/*/*/// */, halt.
