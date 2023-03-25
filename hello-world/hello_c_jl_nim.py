#ifndef __COSMOPOLITAN__
#include <stdio.h>
#endif
#define echo puts /*
#[
#= code visible to Python

echo = print
echo("Hello from \x1b[96mPython\x1b[m!")

""" code visible to Nim ]#

echo("Hello from \x1b[93mNim\x1b[m!")

#[ code visible to Julia =#

echo = println
echo("Hello from \x1b[35mJulia\x1b[m!")

#= code visible to C */

int main() {
echo("Hello from \x1b[90mC\x1b[m!");

// code visible to C, Julia, Nim and Python =##]##"""

echo("Hello from \x1b[90mC\x1b[m, \x1b[35mJulia\x1b[m, \x1b[93mNim\x1b[m and \x1b[96mPython\x1b[m!");

#if 0
#[
""" ";
#endif
}//]##"""
