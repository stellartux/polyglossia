#!/bin/sh
_= #{}--[[ code visible to Shell

print() {
    printf "$1\n"
}
print "Hello from \x1b[32mShell\x1b[m!"

: code visible to Lua ]]--<<=end

local function void() return void end
print "Hello from \x1b[94mLua\x1b[m!"

void
--[[ Code visible to Scheme !#

(define (print x) (display x) (newline))
(print "Hello from \x1b[91mScheme\x1b[m!")

#|
=end
# |#;]]

(print "Hello from \x1b[94mLua\x1b[m, \x1b[91mScheme\x1b[m and \x1b[32mShell\x1b[m!")
