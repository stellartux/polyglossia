#!/bin/sh
# code visible to Shell
set -eu

display() {
    printf "$1"
}
display "Hello from \x1b[32mShell\x1b[m!\n"

true "!#;" code visible to Scheme <<=end

(display "Hello from \x1b[31mScheme\x1b[m\n")

#|
=end
# code visible to Scheme and Shell |#

(display "Hello from \x1b[31mScheme\x1b[m and \x1b[32mShell\x1b[m!\n")
