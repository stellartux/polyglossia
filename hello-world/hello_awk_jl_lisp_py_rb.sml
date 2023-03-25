0;#" ";(*
#|
"#{#\
=begin "#=
""" code visible to Awk "

function puts(s) { print s }

BEGIN {
  msg = "Hello from Awk, Common Lisp, Julia, Python, Ruby and Standard ML!"
  puts("Hello from \x1b[30mAwk\x1b[m!")
  exit
}

# code visible to Common Lisp |#

#||#(defun puts (s) (princ s) (terpri))
#||#(puts "Hello from Common Lisp!")
#||#(defun msg () "Hello from Awk, Common Lisp, Julia, Python, Ruby and Standard ML!")

#|
"""# code visible to Python \
#\
puts=print #\
puts('Hello from \x1b[96mPython\x1b[m!')#\
#\
""" "\
=end # code visible to Julia "{

# =#puts = println
#==#puts("Hello from \x1b[35mJulia\x1b[m!")

# code visible to Standard ML

#*)fun puts s = print s before print "\n";(*
#*)puts "Hello from Standard ML";(*
#*)val(*

# code visible to Julia, Python, Ruby and Standard ML {#"""#*)

msg = "Hello from Awk, Common Lisp, Julia, Python, Ruby and Standard ML!"; 

#" ";(*
#= 
""" code visible to Ruby "

puts("Hello from \x1b[91mRuby\x1b[m!")

}#"
END{# code visible to Awk, Common Lisp, Julia, Ruby and Standard ML =##"""# |#;*)

(puts(msg));

0;#" ";(*
#|
#=
""" "}#"""# =## |#;*)
