#" ";(*
#[
"#{#\
=begin "#=
""" code visible to Awk "

function echo(s) { print s }

BEGIN {
  echo("Hello from \x1b[30mAwk\x1b[m!")
  exit
}

"""# code visible to Python \
#\
echo=print #\
echo('Hello from \x1b[96mPython\x1b[m!')#\
#\
""" "\
=end # code visible to Julia "{

# =#echo = println
#==#echo("Hello from \x1b[35mJulia\x1b[m!")

#= code visible to Standard ML

#*)fun echo s = print s before print "\n";(*
#*)echo "Hello from Standard ML";(*

# code visible to Ruby {

"#{alias echo puts}"
echo("Hello from \x1b[91mRuby\x1b[m!")

# code visible to Nim

#]#echo ("Hello from \x1b[93mNim\x1b[m!")#[

}#"
END{# code visible to Awk, Julia, Nim, Python, Ruby and Standard ML =##"""#]##*)

echo("Hello from Awk, Julia, Nim, Python, Ruby and Standard ML!");

#" ";(*
#=
#[
""" "}#"""# =##]##*)
