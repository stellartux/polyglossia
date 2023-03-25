0//1;#/.to_s.length;'
+0//1;"""
;// code visible to JavaScript

var puts;
if (this == undefined) {
  puts = console.log;
  puts("Hello from \x1b[33mdeno\x1b[m!");
} else if (this.print) {
  puts = print;
  puts("Hello from \x1b[33mqjs\x1b[m!");
} else if (this.display) {
  this.console = { log: puts = function(s) { display(s); newline(); }};
  puts("Hello from \x1b[33mguile\x1b[m!");
} else {
  puts = console.log;
  puts("Hello from \x1b[33mnode\x1b[m!");
}

/* code visible to Python """

puts = print
puts("Hello from \x1b[96mPython\x1b[m!")

'''# code visible to Ruby 

puts("Hello from \x1b[91mRuby\x1b[m!")

# code visible to JavaScript, Python and Ruby '''#*/

puts("Hello from \x1b[33mJavaScript\x1b[m, \x1b[96mPython\x1b[m and \x1b[91mRuby\x1b[m!");
