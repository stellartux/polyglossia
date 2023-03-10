#if 0
# code visible to Shell

puts() {
  RESULT="$1"
  shift 1
  # shellcheck disable=2068
  for SUBSTR in $@; do
      RESULT="$RESULT $SUBSTR"
  done
  printf "$RESULT\n"
}
msg="Hello from \x1b[90mC\x1b[m and \x1b[32mShell\x1b[m!"
puts "Hello from \x1b[32mShell\x1b[m!"

: code visible to C <</**/
#endif

#ifndef __COSMOPOLITAN__
#include <stdio.h>
#endif
#define $msg ("Hello from \x1b[90mC\x1b[m and \x1b[32mShell\x1b[m!")

int main() {
  puts("Hello from \x1b[90mC\x1b[m!");

// code visible to C and Shell
/**/

  puts $msg;

#if 0
: <<}
#endif
}
