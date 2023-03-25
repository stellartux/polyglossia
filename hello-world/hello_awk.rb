"#{#\
=begin code visible to Awk "

function puts(s) { print s }

BEGIN {
  puts("Hello from \x1b[30mAwk\x1b[m!")
  exit
}

"\
=end # code visible to Ruby" {

puts("Hello from \x1b[91mRuby\x1b[m!")

}# code visible to Awk and Ruby "

END {
  puts("Hello from \x1b[30mAwk\x1b[m and \x1b[91mRuby\x1b[m!")
}
