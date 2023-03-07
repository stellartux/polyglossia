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
| JavaScript  | node v19.5.0, deno 1.30.0, qjs 2021-03-27
| Julia       | julia 1.8.5
| Lua         | lua 5.4.4
| Python      | python 3.10.9
| Ruby        | ruby 3.0.5p211
| Shell       | bash 5.1.16(1)-release
| Standard ML | mlton 20210117

## Programs

Test all implementations of a program with `julia test.jl $PROGRAM_NAME`

### hello-world

A selection of polyglot scripts which say "Hello, World!" in different
combinations of languages. They show the comment escaping tricks needed to
combine the languages, and definitions for `print/println/puts`, as a starting
point for unifying output between the languages.

### brainfuck

A Brainfuck interpreter, to demonstrate memory use and a simple CLI.
