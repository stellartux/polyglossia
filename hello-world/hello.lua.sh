#!/bin/bash
_= #{} --[[ code visible to Shell

print() {
    printf "$1\n"
}
print "Hello from \x1b[32mShell\x1b[m!"

: code visible to Lua <<]]

print "Hello from \x1b[94mLua\x1b[m!"

--[[ Code visible to Lua and Shell
]]

print "Hello from \x1b[94mLua\x1b[m and \x1b[32mShell\x1b[m!"
