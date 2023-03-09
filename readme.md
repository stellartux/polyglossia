# Polyglossia

A collection of polyglot programs.

## Languages

### Versions Tested

| Language    | Compiler/Runtime(s)
| -           | -
| Awk         | gawk 5.2.1
| C           | gcc 12.2.1
| Common Lisp | sbcl 2.3.0
| Haskell     | ghc 9.0.2
| JavaScript  | node v19.5.0, deno 1.30.0, qjs 2021-03-27, GNU Guile 3.0.9
| Julia       | julia 1.8.5
| Lua         | lua 5.4.4
| Python      | python 3.10.9
| Ruby        | ruby 3.0.5p211
| Scheme      | GNU Guile 3.0.9
| Shell       | bash 5.1.16(1)-release (POSIX mode)
| Standard ML | mlton 20210117

## Testing

Test all implementations of a program with `julia test.jl $DIRNAME`, or
test a specific file with `julia test.jl $FILENAME`.

## Shebangs

Where possible, each script has a shebang line. In general, if a language is
capable of supporting a shebang line, the shebang line is ignored by the
language runtime, so it can be run by any language regardless of the shebang.
The exception is Ruby, which will not run a script with a shebang line unless
it is the interpreter in the shebang.
