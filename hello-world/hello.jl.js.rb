//#=
//;" code visible to JavaScript

var puts;
if (this == undefined) {
  puts = console.log;
  puts('Hello from \x1b[33mdeno\x1b[m!');
} else if (this.print) {
  puts = print;
  puts('Hello from \x1b[33mqjs\x1b[m!');
} else if (this.display) {
  this.console = { log: puts = function (s) { display(s); newline(); } };
  puts('Hello from \x1b[33mguile\x1b[m!');
} else {
  puts = console.log;
  puts('Hello from \x1b[33mnode\x1b[m!');
}

/* code visible to Ruby "

puts "Hello from \x1b[91mRuby\x1b[m!"

=begin code visible to Julia =#

puts = println
puts("Hello from \x1b[35mJulia\x1b[m!")

#=
=end # code visible to JavaScript, Julia and Ruby *///=#

puts("Hello from \x1b[33mJavaScript\x1b[m, \x1b[35mJulia\x1b[m and \x1b[91mRuby\x1b[m!");
