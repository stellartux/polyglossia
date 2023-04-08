# Polyglossia

A collection of polyglot programs.

## Languages

### Versions Tested

| Language    | Compiler/Runtime(s)
| -           | -
| Awk         | gawk 5.2.1
| C           | gcc 12.2.1
| Clojure     | Clojure 1.11.1
| Common Lisp | sbcl 2.3.0
| D           | gdc (GCC) 12.2.1 20230201
| Haskell     | ghc 9.0.2
| JavaScript  | node v19.5.0, deno 1.30.0, qjs 2021-03-27, GNU Guile 3.0.9
| Julia       | julia 1.8.5
| Lua         | lua 5.4.4
| Nim         | Nim Compiler Version 1.6.10
| Python      | python 3.10.9
| Ruby        | ruby 3.0.5p211
| Scheme      | GNU Guile 3.0.9
| Shell       | bash 5.1.16(1)-release (POSIX mode)
| Standard ML | mlton 20210117

```sh
pacman -S clojure sbcl gdc ghc node deno julia lua nim python ruby guile mlton
```

## Testing

Test all implementations of a program with `julia test.jl $DIRNAME`, or
test a specific file with `julia test.jl $FILENAME`.
