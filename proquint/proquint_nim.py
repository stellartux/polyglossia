#!/usr/bin/env python3
#[ code visible to Python

import sys

def add(xs, x):
  xs.append(x)

echo = print
uint2consonant = "bdfghjklmnprstvz"
uint2vowel = "aiou"

""" code visible to Nim ]#

import std/[algorithm, os, parseutils, sequtils, strutils]

func divmod(x, y: SomeInteger): tuple = (x div y, x mod y)

const uint2consonant = "bdfghjklmnprstvz"
const uint2vowel = "aiou"

proc uint2quint*(i: SomeSignedInt): string = uint2quint(uint64(i))

# code visible to Nim and Python """

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
#[]#    discard parseBiggestUInt(s, n, 0)
    return uint2quint(n)
#[
if __name__ == "__main__":
  params = sys.argv[1:]
  ''' ]#
when declared(commandLineParams):
  let params = commandLineParams()
  # '''
  if len(params) >= 1:
    echo(main(params[0]))
