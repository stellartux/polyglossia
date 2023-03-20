#!/usr/bin/env qjs

const _ = 0/+1;// code visible to JavaScript

var writeln;
if (this == undefined) {
  writeln = console.log;
  writeln("Hello from \x1b[33mdeno\x1b[m!");
} else if (this.print) {
  writeln = print;
  writeln("Hello from \x1b[33mqjs\x1b[m!");
} else {
  writeln = console.log;
  writeln("Hello from \x1b[33mnode\x1b[m!");
}

main();
function main() {

/* code visible to D +/;

import std.stdio;

void main() {
    writeln("Hello from \x1b[31mD\x1b[m!");

// code visible to D and JavaScript */

    writeln("Hello from \x1b[31mD\x1b[m and \x1b[33mJavaScript\x1b[m!");
}
