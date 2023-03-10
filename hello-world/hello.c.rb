#if 0 // code visible to Ruby

def sayHello
  puts("Hello from \x1b[91mRuby\x1b[m!")
end

=begin code visible to C
#endif

#ifndef __COSMOPOLITAN__
#include <stdio.h>
#endif
#define END int main()

void sayHello() {
  puts("Hello from \x1b[90mC\x1b[m!");
}

#if 0
=end
#endif // code visible to C and Ruby

END {
  sayHello();
  puts("Hello from \x1b[90mC\x1b[m and \x1b[91mRuby\x1b[m!");
}
