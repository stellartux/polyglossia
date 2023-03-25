0//1;"""
;// code visible to JavaScript

var print;
if (print) {
  print("Hello from \x1b[33mqjs\x1b[m!");
} else if (this == undefined) {
  print = console.log;
  print("Hello from \x1b[33mdeno\x1b[m!");
} else if (!this.display) {
  print = console.log;
  print("Hello from \x1b[33mnode\x1b[m!");
} else {
  this.console = { log: print = function(s) { display(s); newline(); }};
  print("Hello from \x1b[33mguile\x1b[m!");
}

/* code visible to Python """

print("Hello from \x1b[96mPython\x1b[m!")

# code visible to JavaScript and Python */

print("Hello from \x1b[33mJavaScript\x1b[m and \x1b[96mPython\x1b[m!");
