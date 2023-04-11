#/usr/bin/env lua
(#{} and ""):byte()--[[
  discard false) # code visible to Nim

echo "Hello from \x1b[93mNim\x1b[m!"

#[ code visible to Lua ]]

echo = print
echo "Hello from \x1b[94mLua\x1b[m!"

-- code visible to Lua and Nim ]#

echo "Hello from \x1b[94mLua\x1b[m and \x1b[93mNim\x1b[m!"
