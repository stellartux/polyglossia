#ifndef __COSMOPOLITAN__
#include <stdio.h>
#endif
#if 0 /* code visible to Awk and Julia

function puts(s) #=
{ print s } # =# println(s) end

#= code visible to Awk and C */
#endif

#define BEGIN int main()
#define IS_C 1
BEGIN {
    printf("Hello from \x1b[%s!\x1b[m\n", IS_C ? "90mC" : "30mAwk");

#if 0 /* code visible to Julia
# =#puts("Hello from \x1b[35mJulia\x1b[m!") #*/
#endif // code visible to Awk, C and Julia

    puts("Hello from \x1b[30mAwk\x1b[m, \x1b[90mC\x1b[m and \x1b[35mJulia\x1b[m!");

#if 0
#endif /*
#= */
}
#if 0
#endif // =#
