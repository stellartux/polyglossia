
### Comment Syntax Comparison

| Language\Comment | Begin             | End          | Nested | Notes
| ---------------- | ----------------- | ------------ | ------ | -
| Awk              | `#`               | EOL
| Awk              | ANYPATTERN `{`    | `}`          | ❌     | must parse as Awk syntax
| C                | `//`              | EOL          |        | `\` before EOL to continue to next line
| C                | `/*`              | `*/`         | ❌
| C                | `\n#if 0`         | `\n#endif`   | ✔️
| Clojure          | `;`               | EOL
| Clojure          | `\n#!`            | EOL
| Clojure          | `(comment`        | matching `)` | ✔️     | must parse as Clojure syntax
| Common Lisp      | `;`               | EOL
| Common Lisp      | `#\|`             | `\|#`        | ✔️
| Haskell          | `--`              | EOL
| Haskell          | `{-`              | `-}`         | ✔️
| JavaScript       | `//`              | EOL          |        | EOL includes `\x2028` and `\x2029`
| JavaScript       | `/*`              | `*/`         | ❌
| Julia            | `#`               | EOL
| Julia            | `#=`              | `=#`         | ✔️
| Lua              | `--`              | EOL
| Lua              | `--[[`            | `]]`         | ❌
| Nim              | `#`               | EOL
| Nim              | `#[`              | `]#`         | ✔️
| Nim              | `##[`             | `]##`        | ✔️
| Python           | `#`               | EOL
| Ruby             | `#`               | EOL
| Ruby             | r`\n=begin\s`     | r`\n=end\s`  | ❌
| Scheme           | `;`               | EOL          |        | R5RS
| Scheme           | `#!`              | `!#`         | ❌     | Guile extension
| Scheme           | `#\|`             | `\|#`        | ✔️     | R6RS
| Shell            | `#`               | EOL
| Shell            | r`: .* <<(.*)`    | s`$1`        | ❌
| Shell            | r`true .* <<(.*)` | s`$1`        | ❌
| Standard ML      | `(*`              | `*)`         | ✔️

### Function Call Syntax Comparison

| Language\Syntax |`f(x)`| `f (x)` | `f x` | `(f x)` | 〰️ Notes
| --------------- | ---- | ------- | ----- | ------- | -
| Awk             | ✔️   | 〰️      | 〰️    | ❌      | only `print`
| C               | ✔️   | ✔️      | ❌    | ❌
| Clojure         | ❌   | ❌      | ❌    | ✔️
| Common Lisp     | ❌   | ❌      | ❌    | ✔️
| Haskell         | ✔️   | ✔️      | ✔️    | ✔️
| JavaScript      | ✔️   | ✔️      | ❌    | ❌
| Julia           | ✔️   | ❌      | 〰️    | 〰️      | possible in some cases by overloading implicit multiplication
| Lua             | ✔️   | ✔️      | 〰️    | 〰️      | only for a single literal param
| Nim             | ✔️   | ✔️      | ✔️    | ✔️      | semantic whitespace, `f(x, y)` is not `f (x, y)`
| Python          | ✔️   | ✔️      | ❌    | ❌
| Ruby            | ✔️   | ✔️      | ✔️    | ✔️
| Scheme          | ❌   | ❌      | ❌    | ✔️
| Shell           | ❌   | ❌      | ✔️    | ✔️
| Standard ML     | ✔️   | ✔️      | ✔️    | ✔️

### Writing To `stdout` Comparison

| Language\Method | Write w/ `'\n'` | Write w/o `'\n'`   | Formatted
| --------------- | --------------- | ------------------ | ---------
| Awk             | `print`         |                    | `printf`
| C               | `puts`          |                    | `printf`
| Clojure         | `print`         | `println`          | `printf`
| Common Lisp     |                 | `princ`
| Haskell         | `putStrLn`      | `putStr`
| JavaScript      | `console.log`   |
| Julia           | `println`       | `print`            | `printf`
| Lua             | `print`         | `io.write`         | `io.write(s:format(xs))`
| Nim             | `echo`          | `stdout.write`
| Python          | `print`         | `print(s, end="")` | `print(s.format(xs), end="")`
| Ruby            | `puts`          | `print`            | `printf`
| Scheme          |                 | `display`
| Shell           | `echo`          |                    | `printf`
| Standard ML     |                 | `print`

