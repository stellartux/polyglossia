#" ";(*
"#{#\
=begin code visible to Awk "#=

function puts(s) { print s }

BEGIN {
  puts("Hello from \x1b[30mAwk\x1b[m!")
  exit
}

"\
=end # code visible to Julia "{

# =#puts = println
#==#puts("Hello from \x1b[35mJulia\x1b[m!")

#= code visible to Standard ML

#*)fun puts s = print s before print "\n";(*
#*)puts "Hello from Standard ML";(*

# code visible to Ruby {

puts("Hello from \x1b[91mRuby\x1b[m!")

}#"
END{# code visible to Awk, Julia, Ruby and Standard ML =## *)

puts("Hello from Awk, Julia, Ruby and Standard ML!");

#" ";(*
#=
}# =## *)
