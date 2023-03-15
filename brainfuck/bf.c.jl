#ifndef __COSMOPOLITAN__
#include <stdbool.h>
#include <stddef.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#endif

#if 0 // code visible to Julia

using OffsetArrays

then(x::Integer) = !iszero(x)
then(::Nothing) = false
then(_) = true
Base.:*(x, ::typeof(then)) = then(x)

Base.:!(x::Integer) = iszero(x)

getchar() = read(stdin, Char)
putchar = print ∘ Char
puts = println
strcmp = cmp
strlen = length

zerobased(x) = OffsetVector(collect(x), -1)

#endif

#define then {
#define end }
#define elseif } else if
#define first(X) X[0]
#define UInt8 unsigned char
#define zeros(T, N) (calloc((N), sizeof(T)))
#define zerobased(X) X
#define sign(X) (((X) > 0) - ((X) < 0))

//;#=

char *readchomp(char const* filename) {
    char *result;
    FILE *fp;
    size_t len;
    fp = fopen(filename, "r");
    ssize_t bytes_read = getdelim(&result, &len, '\0', fp);
    fclose(fp);
    if (bytes_read < 0) {
        fprintf(stderr, "Could not open file: '%s'\n", filename);
        exit(1);
    }
    return result;
}

/*=#function findbracket(code, ip, dir)#=*/
int findbracket(char *code, int ip, int dir) {
    char c; //=#
    c = code[ip];
    dir += (c == '[') - (c == ']');
    return dir == 0 ? ip : findbracket(code, ip + sign(dir), dir);
end

//;#=
/*=#function main(argc::Integer, argv::AbstractVector)#=*/
int main(int argc, char **argv) {
    unsigned char* memory;
    char *code = NULL;
    size_t len, ci;
    int c;
    unsigned short mi;

    // code visible to C and Julia =#
    
    if (!argc || !strcmp(argv[1], "--help") || !strcmp(argv[1], "-h")) then
        puts("C/Julia Polyglot Brainfuck Interpreter");
        puts("Usage: (julia bf.c.jl|./bf) FILENAME");
        exit(0);
    end

    code = zerobased(!strcmp(argv[1], "--eval") ? argv[2] : readchomp(argv[1]));
    len = strlen(code);

    memory = zerobased(zeros(UInt8, 65536));
    mi = 0x0000;
    ci = 0;

    while (ci < len) then
        c = code[ci];
        if (c == '+') then
            memory[mi] += 0x01;
        elseif (c == '-') then
            memory[mi] -= 0x01;
        elseif (c == '<') then
            mi -= 0x0001;
        elseif (c == '>') then
            mi += 0x0001;
        elseif (c == '[' || c == ']') then
            if ((memory[mi] == 0) == (c == '[')) then
                ci = findbracket(code, ci, 0);
                continue;
            end
        elseif (c == ',') then
            memory[mi] = getchar(); //# TODO: line based input
        elseif (c == '.') then
            putchar(memory[mi]);
        end
        ci += 1;
    end
end

#if 0
if abspath(PROGRAM_FILE) == @__FILE__
    main(length(ARGS), ARGS)
end
#endif
