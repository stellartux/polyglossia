#!/usr/bin/env ruby
#=
#[ code visible to Nim
"#{#\
=begin code visible to Awk "

function echo(s) { print s }

BEGIN {
  echo("Hello from \x1b[30mAwk\x1b[m!")
  exit
}

# code visible to Julia

# =#echo = println;#=
# =#echo("Hello from \x1b[35mJulia\x1b[m") #=
# =# #=

"\
=end # code visible to Ruby" {

"#{alias echo puts}";
echo("Hello from \x1b[91mRuby\x1b[m!")

}#"
END { # code visible to Nim

#]#echo("Hello from \x1b[93mNim\x1b[m!")

# code visible to Awk, Nim and Ruby ]## =#

echo("Hello from \x1b[30mAwk\x1b[m, \x1b[35mJulia\x1b[m, \x1b[93mNim\x1b[m and \x1b[91mRuby\x1b[m!")

#[
#=
}# =##]#
