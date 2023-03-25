#!/usr/bin/env ruby

_='\''and#{}--[[ code visible to Ruby

puts "Hello from \x1b[91mRuby\x1b[m!"

=begin code visible to Shell '

puts() {
    printf "$1\n"
}
puts "Hello from \x1b[32mShell\x1b[m!"

: code visible to Lua ]]--<<=end

local function void(...) return end
local function puts(x) print(x) return void end
puts "Hello from \x1b[94mLua\x1b[m!"

--[[
=end
# code visible to Lua, Ruby and Shell ]]

(puts "Hello from \x1b[94mLua\x1b[m, \x1b[91mRuby\x1b[m and \x1b[32mShell\x1b[m!")
