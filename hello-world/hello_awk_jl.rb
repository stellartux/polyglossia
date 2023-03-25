#!/usr/bin/env ruby
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

#= code visible to Ruby {

puts("Hello from \x1b[91mRuby\x1b[m!")

}#"
END{# code visible to Awk, Julia and Ruby =#

puts("Hello from \x1b[30mAwk\x1b[m, \x1b[35mJulia\x1b[m and \x1b[91mRuby\x1b[m!")

#=
}# =#
