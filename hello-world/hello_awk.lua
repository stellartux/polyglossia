#!/usr/bin/env lua

tonumber {--x}
#_G}--[[ code visible to Awk

BEGIN {
    print("Hello from \x1b[30mAwk\x1b[m!")

# code visible to Lua

#]] print("Hello from \x1b[94mLua\x1b[m!") --[[

# code visible to Lua and Awk ]]

    print("Hello from \x1b[30mAwk\x1b[m and \x1b[94mLua\x1b[m!")

--x;exit}
