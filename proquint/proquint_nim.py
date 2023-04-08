#!/usr/bin/env python3
#[ code visible to Python

from re import compile as re, finditer
import sys

def add(xs, x):
  xs.append(x)

echo = print

def eachChar(s, r):
  return (m[0][0] for m in finditer(r, s))

def indexDict(s):
  return dict((v, i) for (i, v) in enumerate(s))

def isDecimal(s):
  for c in s:
    if not ('0' <= c <= '9'):
      return False
  return True

def isHexadecimal(s):
  if s.startswith("0x"):
    s = s[2:]
  for c in s:
    if not ('0' <= c <= '9' or 'a' <= c <= 'f' or 'A' <= c <= 'F'):
      return False
  return True

def parseHexInt(x):
  return int(x, 16)

parseUInt = int

""" code visible to Nim ]#

from std/algorithm import reverse
from std/enumerate import enumerate
from std/re import findAll, re, Regex
from std/sequtils import all, allIt
from std/strutils import isDigit, HexDigits, parseUInt, parseHexInt, startsWith
from std/sugar import collect
from std/tables import `[]`, toTable, Table

func divmod(x, y: SomeInteger): tuple = (x div y, x mod y)

iterator eachChar(s: string, r: Regex): char =
  for m in findAll(s, r):
    yield m[0]

proc indexDict(s: string): Table[char, uint] = 
  let k = collect(newSeq):
    for i,v in enumerate(s):
      (v, uint(i))
  k.toTable

proc isDecimal(s: string): bool = s.all(isdigit)

proc isHexadecimal(s: string): bool =
  s.startswith("0x") and s[2..^1].allIt(it in HexDigits)

# code visible to Nim and Python """

#[]#const#[
if True: #]#
  uint2consonant = "bdfghjklmnprstvz"
  uint2vowel = "aiou"
  consonant2uint = indexDict(uint2consonant)
  vowel2uint = indexDict(uint2vowel)

#[]#func quint2uint*(s: string): SomeUnsignedInt =
  ##[Map a quint to an integer, skipping non-coding characters.]## #[
def quint2uint(s):
  "Map a quint to an integer, skipping non-coding characters."
  result = 0
  #]#
  for c in eachChar(s, re(r"[aioubdfghjklmnprstvz]")):
    if c in uint2vowel:
      result = result * 4 + vowel2uint[c]
    else:
      result = result * 16 + consonant2uint[c]
  #[
  return result #]#

#[]#proc uint2quint*(u: SomeUnsignedInt): string =
  ## Map an integer to one to four quints, using `sepchar` to separate them.
  #[]#  var n = u; var r: SomeUnsignedInt #[
def uint2quint(n):
  "Map an integer to one to four quints, using `sepchar` to separate them."
  result = [] #]#
  while n > 0:
    (n, r) = divmod(n, 16)
    add(result, uint2consonant[r])
    (n, r) = divmod(n, 4)
    add(result, uint2vowel[r])
    (n, r) = divmod(n, 16)
    add(result, uint2consonant[r])
    (n, r) = divmod(n, 4)
    add(result, uint2vowel[r])
    (n, r) = divmod(n, 16)
    add(result, uint2consonant[r])
    if n > 0:
      add(result, '-')
  result.reverse() #[
  return "".join(result) #]#

#[]#proc uint2quint*(i: SomeSignedInt): string = uint2quint(uint64(i))

#[
if __name__ == "__main__":
  argv = sys.argv[1:]
#]#when isMainModule:
#[]#  import std/os
#[]#  let argv = commandLineParams()
  for arg in argv:
    if isDecimal(arg):
      echo(uint2quint(parseUInt(arg)))
    elif isHexadecimal(arg):
      echo(uint2quint(parseHexInt(arg)))
    else:
      echo(quint2uint(arg))
