#!/bin/sh

#[ code visible to Shell

println() { printf "$1\n"; }
println "Hello from \x1b[32mShell\x1b[m!"

: code visible to Nim <<]#

proc println(s: string) = echo s
println "Hello from \x1b[93mNim\x1b[m!"

#[ code visible to Nim and Shell
]#

println "Hello from \x1b[93mNim\x1b[m and \x1b[32mShell\x1b[m!"
