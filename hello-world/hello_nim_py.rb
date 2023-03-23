#!/usr/bin/env ruby
#[
""" code visible to Ruby "

alias echo puts
echo("Hello from \x1b[91mRuby\x1b[m!")

=begin code visible to Python """

echo = print
echo("Hello from \x1b[96mPython\x1b[m!")

"""  code visible to Nim ]#

echo("Hello from \x1b[93mNim\x1b[m!")

#[
=end #]## code visible to Nim and Python """

echo("Hello from \x1b[93mNim\x1b[m and \x1b[96mPython\x1b[m!")
