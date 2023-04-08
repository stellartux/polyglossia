#!/usr/bin/env python3

#[ Python

echo = print
parseUInt = int
success = "proquint_nim.py - All Python tests passed."

def lines(filename):
    with open(filename) as f:
        return f.readlines()

import proquint_nim as PQ

''' Nim ]#

import std/strutils
import "proquint_nim.py" as PQ

let success = "proquint_nim.py - All Nim tests passed."
var
  s, n: string
  u: uint

# Nim and Python '''

for line in lines("testcases.tsv"):
    (s, n) = line.split()
    u = parseUInt(n)
    assert PQ.uint2quint(u) == s
    # assert PQ.quint2uint(s) == u

echo(success)
