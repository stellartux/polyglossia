Location = 0; --Location;/* code visible to Lua
-- rename `Location` to `_` to make this script work in Guile
-- at the expense of making this script no longer work in Deno

print("Hello from \x1b[94mLua\x1b[m!")

--[[ code visible to JavaScript */

var print;
if (!this) {
  print = console.log;
  print("Hello from \x1b[33mdeno\x1b[m!");
} else if (this.print) {
  print("Hello from \x1b[33mqjs\x1b[m!");
} else if (this.display) {
  this.console = { log: print = function (s) { display(s); newline(); } };
  print("Hello from \x1b[33mGuile\x1b[m!");
} else {
  print = console.log;
  print("Hello from \x1b[33mnode\x1b[m!");
}

// code visible to JavaScript and Lua ]]

print("Hello from \x1b[33mJavaScript\x1b[m and \x1b[94mLua\x1b[m!");
