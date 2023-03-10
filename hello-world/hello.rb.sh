#!/usr/bin/env ruby

true and '\'' # code visible to Ruby

puts "Hello from \x1b[91mRuby\x1b[m!"

=begin code visible to Shell '

puts() { printf "$1\n"; }
puts "Hello from \x1b[32mShell\x1b[m!"

: '
=end # code visible to Ruby and Shell '

puts "Hello from \x1b[91mRuby\x1b[m and \x1b[32mShell\x1b[m!"
