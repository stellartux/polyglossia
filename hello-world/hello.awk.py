#!/bin/awk

""" " == 0 {}
# code visible to Python
# """;"""
# """; print("Hello from \x1b[96mPython\x1b[m"); """

# code visible to Awk

BEGIN {
print("Hello from \x1b[30mAwk\x1b[m!")

# code visible to Awk and Python """

print("Hello from \x1b[30mAwk\x1b[m and \x1b[96mPython\x1b[m!")
exit(0)

""" "
}#"""
