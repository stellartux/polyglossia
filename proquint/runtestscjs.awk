#!/usr/bin/awk

BEGIN {
  print("make -s o/proquint_c") | "sh"
}

function assert(x, m) {
  if (!x) {
    print(m)
    exit(1)
  }
}

{
  ("o/proquint_c " $1) | getline result
  assert(result == $2, "quint2uint('"$1"'): expected "$2", got " result)
  ("o/proquint_c " $2) | getline result
  assert(result == $1, "uint2quint("$2"): expected "$1", got " result)
  ("qjs --std proquint/proquint_c.js " $1) | getline result
  assert(result == $2, "quint2uint('"$1"'): expected "$2", got " result)
  ("qjs --std proquint/proquint_c.js " $2) | getline result
  assert(result == $1, "quint2uint("$2"): expected "$1", got " result)
}

END { print "proquint_c.js - All tests passed." }

