/*/* Code visible to JavaScript */

const println = console.log
println("Hello from \e[33mJavaScript\e[m!")

;` Code visible to Prolog */

println(S) :- format("~s\n", [S]).

:- println("Hello from \x1b[38:5:202mProlog\x1b[0m").

:- % code visible to JavaScript and Prolog `

println("Hello from \x1b[33mJavaScript\x1b[0m and \x1b[38:5:202mProlog\x1b[0m!")

/*/*/// */.