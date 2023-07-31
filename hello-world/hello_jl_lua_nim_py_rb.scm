#!/usr/bin/env ruby
(#{} and ""):byte()--[[
#=
#[
''' code visible to Ruby '
)

alias echo puts
echo("Hello from \x1b[91mRuby\x1b[m!")

=begin # code visible to Python ''')

echo = print
echo("Hello from \x1b[96mPython\x1b[m!")

if True:
  ''' code visible to Nim ]# discard false)

echo("Hello from \x1b[93mNim\x1b[m!")
const

#[ code visible to Julia =#)

echo = println
echo("Hello from \x1b[35mJulia\x1b[m!")

#= code visible to Lua ]]

echo = print
echo("Hello from \x1b[94mLua\x1b[m!")
msg = "Hello from \x1b[35mJulia\x1b[m, \x1b[94mLua\x1b[m, \x1b[93mNim\x1b[m, \x1b[96mPython\x1b[m, \x1b[91mRuby\x1b[m and \x1b[31mScheme\x1b[m!";
function discard(...) return discard end
discard

--[[ code visible to Scheme !#

(define (echo s) (display s) (newline))
(echo "Hello from \x1b[31mScheme\x1b[m!")
(define (msg) "Hello from \x1b[35mJulia\x1b[m, \x1b[94mLua\x1b[m, \x1b[93mNim\x1b[m, \x1b[96mPython\x1b[m, \x1b[91mRuby\x1b[m and \x1b[31mScheme\x1b[m!")

#|
=end
# code visible to Julia, Nim, Python and Ruby # ]## =## '''

  msg = "Hello from \x1b[35mJulia\x1b[m, \x1b[94mLua\x1b[m, \x1b[93mNim\x1b[m, \x1b[96mPython\x1b[m, \x1b[91mRuby\x1b[m and \x1b[31mScheme\x1b[m!"

# code visible to Julia, Lua, Nim, Python, Ruby and Scheme |#;]]

(echo(msg))
