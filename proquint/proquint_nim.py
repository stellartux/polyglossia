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

""" code visible to Nim ]#

import std/[algorithm, enumerate, os, re, sequtils, strutils, sugar, tables]

iterator eachChar(s: string, r: Regex): char =
  for m in findAll(s, r):
    yield m[0]

proc indexDict(s: string): Table[char, uint] = 
  let k = collect(newSeq):
    for i,v in enumerate(s):
      (v, uint(i))
  k.toTable

func divmod(x, y: SomeInteger): tuple = (x div y, x mod y)

proc uint2quint*(i: SomeSignedInt): string = uint2quint(uint64(i))

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

#[]#proc main(s: string): string = #[#
def main(s):
  found_uint = True
  try:
    n = int(s)
  except:
    found_uint = False
  ''' ]#
  var n: BiggestUInt
  let found_uint = s.all(isdigit)
  # '''
  if found_uint:
#[]#    n = parseUInt(s)
    return uint2quint(n) #[
  return quint2uint(s) #]#
#[]#  return $quint2uint(s)
#[
if __name__ == "__main__":
  params = sys.argv[1:]
  ''' ]#
when declared(commandLineParams):
  let params = commandLineParams()
  # '''
  if len(params) >= 1:
    echo(main(params[0]))
