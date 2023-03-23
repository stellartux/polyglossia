#!/usr/bin/awk
#[ code visible to AWk

function echo(s) { print s }

BEGIN {
  echo("Hello from \x1b[30mAwk\x1b[m!")

# code visible to Nim

#]#echo("Hello from \x1b[93mNim\x1b[m!")

# code visible to Awk and Nim

echo("Hello from \x1b[30mAwk\x1b[m and \x1b[93mNim\x1b[m!")

#[
}#]#
