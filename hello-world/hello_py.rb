#!/usr/bin/env ruby
''' Code only visible to Ruby '
puts("Hello from \x1b[91mRuby\x1b[m!")

=begin Code only visible to Python '''

puts = print
puts("Hello from \x1b[96mPython\x1b[m!")

'''
=end # Code visible to Python and Ruby '''

puts("Hello from \x1b[96mPython\x1b[m and \x1b[91mRuby\x1b[m!")
