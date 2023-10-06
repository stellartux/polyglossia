# Viable Language Combinations

---- | awk | c | clj | lisp | d | hs | js | jl | lua | nim | py | rb | scm | sh
---- | --- | - | --- | ---- | - | -- | -- | -- | --- | --- | -- | -- | --- | --
sml  | 〰️  |   | 〰️  |  〰️  |   | ✔️ |    | 〰️ | 〰️  | 〰️  | 〰️ | 〰️ |  〰️ | 〰️
sh   | ❌  |〰️ |     |  〰️  |   | 〰️ |    | ❌ | 〰️  | 〰️  | ❌ | 〰️ |  〰️ | 🟰
scm  |     |〰️ | ✔️  |  ✔️  |   | ✔️ | 〰️ | 〰️ | 〰️  | 〰️  | 〰️ | 〰️ |  🟰  |
rb   | 〰️  |✔️ |     |  〰️  |   | 〰️ | 〰️ | ✔️ | 〰️  | 〰️  | ✔️ | 🟰  |
py   | 〰️  |〰️ |     |  〰️  |   | 〰️ | 〰️ | ✔️ | 〰️  | ✨  | 🟰  |
nim  | 〰️  |〰️ |     |  〰️  |   | 〰️ |    | ✔️ | 〰️  |  🟰  |
lua  | 〰️  |   |     |  〰️  |   | ✔️ | 〰️ | ✨ |  🟰  |
jl   | ✔️  |✔️ |     |  〰️  |   | ✔️ | 〰️ | 🟰  |
js   | ✔️  |✨ |     |  〰️  |〰️ | 〰️ | 🟰  |
hs   | 〰️  |〰️ | 〰️  |  ✔️  |〰️ | 🟰  |
d    |     |✔️ |     |      | 🟰 |
lisp | 〰️  |〰️ | ✔️  |  🟰   |
clj  | 〰️  |   |  🟰  |
c    | 〰️  | 🟰 |

- ✨ - proof of concept completed
- ✔️ - potential to work well
- 〰️ - have shared a hello world together
- ❌ - seems impossible
- 🟰  - these are the same language

## What Makes A Good Combination

### Comment Escaping

Being able to write text which appears to be a comment in one language and code
in another is the bare minimum for writing non-trivial polyglot code.

The simplest kind of polyglot file is one where several languages coexist
without any code sharing, like in the following snippet, which can be executed
as Julia or as a shell script. All the shell code is commented out in Julia, and
all the Julia code is commented out in shell.

```julia,sh
#=
echo "Hello from Shell!"
: <<=#
println("Hello from Julia!") #=
=#
```

### Function Call Syntax

Shared function call syntax is necessary to be able to do anything in both
languages at once.

### Conditional Syntax

Having some method of choosing whether to execute a code path or not is
necessary to write any non-trivial program.

### Function Definition Syntax

While not strictly necessary, a means of simultaneously defining functions in
both languages at once allows a larger portion of the codebase to only be
written once.

## Combinations

### Awk and JavaScript

```awk
function fib(n) {
    if (n < 2) {
        return 1
    } else {
        return fib(n - 1) + fib(n - 2)
    }
}
```

### C and JavaScript

Despite having identical single line and multi-line comment syntax, escaping
between C and JavaScript is surprisingly easy. Two techniques are possible, both
relying on differences in how C and JavaScript interpret the end of a line.

Both languages see `'\n'` as introducing a new line, but JavaScript also
considers the characters ` ` (line separator) and ` ` (paragraph separator) to
introduce a new line. By starting a single line comment in both languages,
then placing one of the Unicode separators, a new multi-line comment can be
started in JavaScript that won't be seen by C. The following lines have escaped
into C only code.

```c
// A comment in C and JS  /* multi-line comment in JS, but same comment in C
```

Alternatively, C interprets a `\` as the final character of a single comment as
continuing that comment onto the next line, where JavaScript sees the end of the
comment. Starting a multiline comment on the next line escapes into C only code
for the following lines.

```c
// A comment in C and JS \
/* multiline comment in JS, but single line comment from the previous line in C
```

Both techniques are equivalent, the first can be more compact, the second is
easier to type because all of the characters required are ASCII. Some JavaScript
syntax highlighters fail to recognise the Unicode line endings, so the second
technique can be useful since being able to switch back and forth between
syntax highlighting modes helps with double-checking polyglot code. It also
makes the functions look like they're wearing a little hat.

```c
//\
function fib(x) { /*
unsigned fib(unsigned x) { // */
  return x > 1 ? fib(x - 1) + fib(x - 2) : 1;
}
```

With either escape technique, it's possible to swap back and forth between C
and JS multi-line comments with `/*/`, which is neater than most language pairs.

```c
// this line is both \
/* this line is JS
// this line is C
/*/
// this line is JS
/*/
// this line is C */
// this line is both
```

### Common Lisp and Scheme

Common Lisp and Scheme are both quite similar in syntax due to being
S-expression based languages. Both languages have homoiconic macros, so it's
possible to define macros which convert between `defvar`/`defun` and
`define` expressions.

```lisp
#!/usr/bin/guile
(macro defun (name args . rest)
 (cons 'defun (cons (cons name args) rest))) ;!#

(defun fibonacci (x)
 (if (> x 1)
  (+ (fib (- n 1)) (fib (- n 2)))
  1))
```

#### ...and Clojure

Clojure's `[]` syntax for vectors makes it impossible to for Scheme or Common
Lisp to fit Clojure's syntax for function definitions, but it's possible to
write `defun`/`define` macros in Clojure which imitate CL/Scheme style.

### Julia and Lua

Julia and Lua's comment syntaxes don't overlap, but Julia's comment syntax is
Lua's length prefix operator, so it's only necessary to write enough code in
both languages until it's valid to get the length of something, then it's
trivial to escape into a multiline Lua comment. Combining this with the
`then = true` trick for uniting Lua and Julia's `if` statement syntax, it's
quite easy to write Julia and Lua polyglot code.

```lua
local _ = #{}--[[
then = true #]]

function fib(n)
    if n < 2 then
        return 1
    else
        return fib(n - 1) + fib(n - 2)
    end
end
```

### Julia and Ruby

`#=` starts a single line comment in Ruby and a multiline comment in Julia.
This makes it trivial to escape between languages. Combined function
declarations, despite the differing `def`/`function` keywords, are relatively
straightforward.

```julia
#==# function #=
def # =#
fib(n)
    if n < 2
        1
    else
        fib(n - 1) + fib(n - 2)
    end
end
```

### Nim and Python

```python
#[]#proc fib(n: int): int = #[
def fib(n): #]#
    if n < 2:
        return 1
    else:
        return fib(n - 1) + fib(n - 2)
```

### Comment Syntax Comparison

| Language\Comment | Begin             | End          | Nested | Notes
| ---------------- | ----------------- | ------------ | ------ | -----
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
| Crystal          | `#`               | EOL
| D                | `//`              | EOL
| D                | `/*`              | `*/`         | ❌
| D                | `/+`              | `+/`         | ✔️
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
| Prolog           | `%`               | EOL
| Prolog           | `/*`              | `*/`         | ✔️
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

| Language\Syntax |`f(x)`| `f (x)` | `f x` | `(f x)` | 〰️ Notes
| --------------- | ---- | ------- | ----- | ------- | --------
| Awk             | ✔️   | 〰️      | 〰️    | ❌      | only `print`
| C               | ✔️   | ✔️      | ❌    | ❌
| Clojure         | ❌   | ❌      | ❌    | ✔️
| Common Lisp     | ❌   | ❌      | ❌    | ✔️
| Crystal         | ✔️   | ✔️      | ✔️    | ✔️
| D               | ✔️   | ✔️      | ❌    | ❌
| Haskell         | ✔️   | ✔️      | ✔️    | ✔️
| JavaScript      | ✔️   | ✔️      | ❌    | ❌
| Julia           | ✔️   | ❌      | 〰️    | 〰️      | possible in some cases by overloading implicit multiplication
| Lua             | ✔️   | ✔️      | 〰️    | 〰️      | only for a single literal param
| Nim             | ✔️   | ✔️      | ✔️    | ✔️      | semantic whitespace, `f(x,y)` is not `f (x,y)`
| Prolog          | ✔️   | ❌      | ❌    | ❌
| Python          | ✔️   | ✔️      | ❌    | ❌
| Ruby            | ✔️   | ✔️      | ✔️    | ✔️
| Scheme          | ❌   | ❌      | ❌    | ✔️
| Shell           | ❌   | ❌      | ✔️    | ✔️
| Standard ML     | ✔️   | ✔️      | ✔️    | ✔️

#### Vararg Syntax Comparison

| Language\Syntax | Opt | Var | Kwargs | Undercall
| --------------- | :-: | :-: | :----: | ---------
| Awk             | ❌  | ❌  | ❌     | ✔️
| C               | ❌  | ✔️  | ❌     | ❌
| Clojure         | ✔️  | ✔️  | ✔️     | ❌
| Common Lisp     | ✔️  | ✔️  | ✔️     | ❌
| Crystal         | ✔️  | ✔️  | ✔️     | ✔️
| Haskell         | ❌  | ❌  | ❌     | ❌
| JavaScript      | ✔️  | ✔️  | ❌     | ✔️
| Julia           | ✔️  | ✔️  | ✔️     | 〰️
| Lua             | 〰️  | ✔️  | ❌     | ✔️
| Nim             | ✔️  | ✔️  | ✔️     | ❌
| Prolog          | ❌  | ❌  | ❌     | ❌
| Python          | ✔️  | ✔️  | ✔️     | ✔️
| Ruby            | ✔️  | ✔️  | ✔️     | ✔️
| Scheme          | ✔️  | ✔️  | ✔️     | ❌
| Standard ML     | ❌  | ❌  | ❌     | ❌

- Opt: Optional arguments
- Var: Trailing varargs
- Kwargs: Keyword arguments
- Undercall: Functions can be called with fewer params than declared

##### JavaScript: Arguments

```js
/**
 * @param {any} x required
 * @param {integer} [y=0] optional
 * @param {...any} zs varargs
 */
function f(x, y = 0, ...zs) {
    for (const z of zs) {
        console.log(z)
    }
}
```

##### Julia: Arguments

```julia
function f(x, y::Integer=0, zs...; kwarg=true, kwargs...)
    for z in zs
        println(z)
    end
end
```

Positional arguments and keyword arguments are seperated by a semicolon.

##### Lua: Arguments

```lua
---@param x any required
---@param y integer? optional
---@param ... any vararg
function f(x, y, ...)
    y = y or 0
    for i = 1, select("#", ...) do
        local z = select(i, ...)
        print(z)
    end
end
```

Because of Lua's specific syntax for varargs, a function can only refer to a
vararg declared in its own scope. Varargs passed to inner functions must be
wrapped in a table.

```lua
function outer(...)
    local varargs = table.pack(...)
    local function inner(i)
        return varargs[i]
    end
    return inner
end
```

##### Python: Arguments

```python
def f(x, y: int = 0, *zs, **kwargs):
    for z in zs:
        print(z)
```

In Python, arguments are both positional and keyword. `f(1, 2)` and
`f(y = 2, x = 1)` are equivalent. The `**kwargs` argument is a table holding
additional keyword arguments not defined in the function signature.

### Writing To `stdout` Comparison

| Language\Method | Write w/ `'\n'` | Write w/o `'\n'`   | Formatted
| --------------- | --------------- | ------------------ | ---------
| Awk             | `print`*        | `print`*           | `printf`
| C               | `puts`          |                    | `printf`
| Clojure         | `println`       | `print`            | `printf`
| Common Lisp     |                 | `princ`            |
| D               | `writeLn`       | `write`            | `writef`
| Haskell         | `putStrLn`      | `putStr`           |
| JavaScript      | `console.log`   |                    |
| Julia           | `println`       | `print`            | `printf`
| Lua             | `print`         | `io.write`         | `io.write(s:format(...))`
| Nim             | `echo`          | `stdout.write`     |
| Prolog          | `writeln`       | `write`            | `format`
| Python          | `print`         | `print(s, end="")` | `print(s.format(xs), end="")`
| Ruby            | `puts`          | `print`            | `printf`
| Scheme          |                 | `display`          |
| Shell           | `echo`          |                    | `printf`
| Standard ML     |                 | `print`            |

#### `stdout` Notes

##### Awk `print`

The `print` function in awk prints the given strings, joined by `ORS`, followed
by `OFS`. The default values are `ORS=" "; OFS="\n"` which make `print` in Awk
equivalent to `print` in Python and QuickJS. By changing the values of `ORS` and
`OFS`, Awk's `print` can match the behaviour of other languages' `print`
functions.

```awk
# Julia style `print` and `println`
BEGIN { ORS=OFS="" }
function println(s) { print(s "\n") }
```

```awk
# Lua style
BEGIN { OFS="\t" }
```

##### Lua `printf`

```lua
function printf(s, ...) io.write(s:format(...)) end
```

##### Python `printf`

```python
def printf(s, *args, **kwargs):
    print(s.format(*args), end="", **kwargs)
```

### Shebang Support

| Language        | Shebang Line
| --------------- | ------------
| Awk             | ✔️
| C               | ❌
| Clojure         | ✔️
| Common Lisp     | ✔️
| Crystal         | ✔️
| D               | ✔️
| Haskell         | ✔️
| JavaScript      | ✔️
| Julia           | ✔️
| Lua             | ✔️
| Nim             | ✔️
| Prolog          | ✔️
| Python          | ✔️
| Ruby            | 〰️ (only if it points to Ruby)
| Scheme          | ✔️
| Shell           | ✔️
| Standard ML     | ❌

### Filename Restrictions

| Language        | Restriction
| ----------------| -----------
| D               | Filename must end in `.d`
| Lua             | Filename must end in `.lua` if imported as a module
| Nim             | Basename without extension cannot have `.`
| Python          | Filename must end in `.py` if imported as a package
| Standard ML     | Filename must end in `.sml`

### Quotation Syntax

| Language\Syntax |  `"a"` | `'a'`       | ``` `a` ```      | `"""a"""`
| --------------- | ------ | ----------- | ---------------- | ---------
| Awk             | String | String      |                  | `"a"`
| C               | String | Char        |                  | `"a"`
| Clojure         | String |
| Common Lisp     | String |
| D               | String | Char        |                  | TODO
| Haskell         | String | Char        | Prefix to infix  |
| JavaScript      | String | String      | Multiline string |
| Julia           | String | Char        | Command          | Multiline string
| Lua             | String | String
| Nim             | String | Char        | Infix to prefix  | Multiline string
| Prolog          | String/Symbol | Symbol      | String (List of codes)
| Python          | String | String      |                  | `"a"`
| Ruby            | String | String      |                  | `"a"`
| Scheme          | String | Symbol `a'` | Symbol           | `"" "a" ""`
| Shell           | String | String      |
| Standard ML     | String |

### Non-Breaking Space `" "`

Ruby considers non-breaking space to be an identifier character, most languages
consider it whitespace. This allows for Ruby keywords to be used in situations
that would otherwise be impossible, as " " can be appended to the keyword to
make it an identifier in Ruby but the same word in any other language.

### Docstring

| Language          | *  | Style       | Position | View              | Search          | Notes
| ----------------- | -- | ------------| -------- | ----------------- | --------------- | -
| Awk               | ❌ |
| C                 | 〰️ | `///`       | Before
| C                 | 〰️ | `/**` `*/`  | Before
| Clojure           | ✔️ | String      | After    | [`doc`]           | [`find-doc`]
| Common Lisp       | ✔️ | String      | After    | [`documentation`] | [`apropos`]
| [D][d-doc]        | ✔️ | `///`       | After
| [D][d-doc]        | ✔️ | `/**` `*/`  | Before
| [D][d-doc]        | ✔️ | `/++` `+/`  | Before
| [Haskell][hs-doc] | 〰️ | `-- \|`     | Before   |                   |                 | At the REPL, `:type fn` `:info sym` `:kind type` or `:browse module`
| [Haskell][hs-doc] | 〰️ | `-- ^`      | After
| [Haskell][hs-doc] | 〰️ | `{-\|` `-}` | Before
| JavaScript        | 〰️ | `/**` `*/`  | Before
| [Julia][jl-doc]   | ✔️ | String      | Before   | `Docs.doc`        | `apropos`       | At the REPL, `?x` for `Docs.doc`, `?"x"` for `apropos`
| Lua               | 〰️ | `---`       | Before
| Nim               | ✔️ | `##`        | After    |                                     | `nim doc $FILENAME` in shell to generate docs
| Nim               | ✔️ | `##[` `]##` | After
| [Prolog][pl-doc]  | ✔️ | `%!`        | Before
| Python            | ✔️ | String      | After    | `fn.__doc__`
| [Ruby][rb-doc]    | ✔️ | `#`         | Before
| Scheme            | ✔️ | String      | After    | `describe`, `procedure-documentation` |                 | Chicken Scheme has an [`apropos` egg].
| Shell             | 〰️ | `# .DOCUMENTS fn` `# .ENDOC` | Anywhere
| Standard ML       | ❌ |

#### Docstring Table Key

- ✔️ Official language feature
- 〰️ De facto standard
- ❌ Unsupported

[`apropos`]: http://www.lispworks.com/documentation/HyperSpec/Body/f_apropo.htm
[`apropos` egg]: http://wiki.call-cc.org/eggref/5/apropos
[d-doc]: https://dlang.org/spec/ddoc.html
[`doc`]: https://clojuredocs.org/clojure.repl/find-doc
[`documentation`]: (http://www.lispworks.com/documentation/HyperSpec/Body/f_docume.htm#documentation)
[`find-doc`]: https://clojuredocs.org/clojure.repl/find-doc
[hs-doc]: https://haskell-haddock.readthedocs.io/en/latest/markup.html#documentation-and-markup
[jl-doc]: https://docs.julialang.org/en/v1/manual/documentation/#man-documentation
[pl-doc]: https://www.swi-prolog.org/pldoc/doc_for?object=section(%27packages/pldoc.html%27)
[rb-doc]: (https://ruby-doc.org/3.2.1/RDoc/MarkupReference.html#class-RDoc::MarkupReference-label-Markup+in+Comments)

#### REPL Support

| Language          | multiline | debugger | command                     | debug function
| ----------------- | --------- | -------- | --------------------------- | ---
| Clojure           |  ✔️       |          | `clj`
| Common Lisp       |  ✔️       |  ✔️      | `sbcl`
| Crystal           |  ✔️       |          | `crystal i`
| Haskell           |  ✔️       |          | `ghci`
| JavaScript        |  ✔️       |  〰️      | `node`, `deno repl`, `qjs`  | `debugger`
| Julia             |  ✔️       |          | `julia`
| Lua               |           |  〰️      | `lua`                       | `debug.debug()`
| Nim               |           |          | `nim secret`
| Prolog            |  ✔️       |  ✔️      | `swipl`
| Python            |  ✔️       |          | `python`
| Ruby              |  ✔️       |          | `irb`
| Scheme            |           |  ✔️      | `guile`
| Shell             |  ✔️       |          | `sh`
| Standard ML       |           |          | `smlnj`, `sosml`

#### Operators

##### Arithmetic Operators

| Language\Op     | neg  | floor division         | modulo         | remainder         | exponent
| --------------- | ---- | ---------------------- | -------------- | ----------------- | ----
| Awk             | `-a` | `int(a / b)`           |                | `a % b`           | `a ** b` `a ^ b`
| C               | `-a` | `a / b`                |                | `a % b`           | `a ** b`
| Clojure         | `-a` | `(div a b)`            | `(mod a b)`    | `(rem a b)`       | `(Math/pow a b)`
| Common Lisp     | `-a` | `(floor a b)`          | `(mod a b)`    | `(rem a b)`       | `(expt a b)`
| Crystal         | `-a` | `a // b`               | `a % b`        | `a.remainder(b)`  | `a ** b`
| D               | `-a` | `a / b`                |                | `a % b`           | `a ** b`
| Haskell         | `-a` | `div a b`              | `mod a b`      | `rem a b`         | `a ** b`
| JavaScript      | `-a` | `a / b \| 0`           |                | `a % b`           | `a ** b`
| Julia           | `-a` | `a ÷ b`                | `mod(a, b)`    | `a % b`           | `a ^ b`
| Lua             | `-a` | `a // b`               | `a % b`        |                   | `a ^ b`
| Nim             | `-a` | `a div b`              |                | `a mod b`
| Prolog          | `-a` | `a // b`, `a div b`    | `a mod b`      | `a rem b`         | `a ^ b`
| Python          | `-a` | `a // b`               | `a % b`        |                   | `a ** b`
| Ruby            | `-a` | `a.div(b)`             | `a % b`        | `a.remainder(b)`  | `a ** b`
| Scheme          | `-a` | `(floor-quotient a b)` | `(modulo a b)` | `(remainder a b)` | `(expt a b)`
| Shell           | `-a` | `expr $a / $b`         |                | `expr $a % $b`
| Standard ML     | `~a` | `a div b`              | `a mod b`

Defining modulo and remainder so that `-5 modulo 3 == 1` and `-5 remainder 3 == -2`.

###### Awk / JavaScript Modulo

```javascript
function mod(a, b) {
    return (a % b + b) % b
}
```

###### Python Remainder

```python
def rem(a, b):
    return a % b - (b if a < 0 else 0)
```

##### Concatenation Operators

| Language\Op     | strings  | arrays          | numbers
| --------------- | -------- | --------------- | -------
| Awk             | `a b`
| Clojure         |
| Common Lisp     |
| Haskell         | `a ++ b` | `a ++ b`
| JavaScript      | `a + b`  | `[...a, ...b]`  | `'' + a + b`
| Julia           | `a * b`  | `[a; b]`
| Lua             | `a .. b` | see below       | `a .. b`
| Nim             | `a & b`  | `a & b`         | `$a & $b`
| Python          | `a + b`  | `a + b`
| Ruby            | `a + b`  | `a + b`
| Scheme          |
| Shell           | `"$a$b"`
| Standard ML     | `a ^ b`  | `a ^ b`

###### Lua List Concat

```lua
--- Concatenate the given lists into a new list.
---@generic T
---@param a T[]
---@param ... T[]
---@return T[]
function concat(a, ...)
    a = table.pack(table.unpack(a))
    for i = 1, select("#", ...) do
        local b = select(i, ...)
        table.move(b, 1, #b, #a + 1, a)
    end
    return a
end
```

##### Array Indexing

| Language        | First | Negative Indices | Last                  | Notes
| --------------- | ----- | ---------------- | --------------------- | ------------
| Awk             |     1 | Hash Key         | `xs[length(xs)-1]`
| C               |     0 | Out of bounds    | Static arrays
| Crystal         |     0 | Index from end   | `xs.last`, `xs[-1]`
| D               |     0 | Out of bounds    | Static arrays
| JavaScript      |     0 | Hash Key         | `xs[xs.length-1]`
| Julia           |     1 | Out of bounds    | `last(xs)`, `xs[end]`
| Lua             |     1 | Hash Key         | `xs[#xs]`
| Prolog          |   0/1 | Out of bounds    | `last(Xs, X)`         | `nth0(N, Xs, X)` or `nth1(N, Xs, X)`
| Python          |     0 | Index from end   | `xs[-1]`
| Ruby            |     0 | Index from end   | `xs.last`, `xs[-1]`

##### Comparison Operators

| Language\Op     | equal            | not equal         | strict equal | strict not equal
| --------------- | ---------------- | ----------------- | ------------ | ----------------
| Awk             | `a == b`         | `a != b`
| C               | `a == b`         | `a != b`          | `a === b`    | `a !== b`
| D               | `a == b`         | `a != b`          | `a === b`    | `a !== b`
| Haskell         | `a == b`         | `a /= b`
| JavaScript      | `a == b`         | `a != b`          | `a === b`    | `a !== b`
| Julia           | `a == b`         | `a != b`, `a ≠ b` | `a === b`    | `a !== b`
| Lua             | `a == b`         | `a ~= b`
| Nim             | `a == b`         | `a != b`
| Prolog          | `a = b`          | `a \= b`
| Prolog CLP(FD)  | `a #= b`         | `a #\= b`, `dif(a, b)`
| Python          | `a == b`         | `a != b`
| Ruby            | `a == b`         | `a != b`          | `a === b`    | `a !== b`
| Shell           | `expr $a -eq $b` | `expr $a -neq $b`
| Standard ML     | `a = b`          | `a <> b`

- [Scheme Equality](https://www.gnu.org/software/guile/manual/html_node/Equality.html)

##### Logical Operators

| Language\Op     | and                 | or                   | not
| --------------- | ------------------- | -------------------- | ---
| Awk             | `a && b`            | `a \|\| b`           | `!a`
| C               | `a && b`            | `a \|\| b`           | `!a`
| Clojure         | `(and a b)`         | `(or a b)`           | `(not a)`
| Common Lisp     | `(and a b)`         | `(or a b)`           | `(not a)`
| D               | `a && b`            | `a \|\| b`           | `!a`
| Haskell         | `a && b`            | `a \|\| b`           | `not a`
| JavaScript      | `a && b`            | `a \|\| b`           | `!a`
| Julia           | `a && b`            | `a \|\| b`           | `!a`
| Lua             | `a and b`           | `a or b`             | `not a`
| Nim             | `a and b`           | `a or b`             | `not a`
| Prolog          | `a, b`              | `a; b`, `a | b`      | `\+ a`
| Prolog CLP(B)   | `a #/\ b`           | `a #\/ b`            | `#\ a`
| Python          | `a and b`           | `a or b`             | `not a`
| Ruby            | `a && b`, `a and b` | `a \|\| b`, `a or b` | `!a`
| Scheme          | `(and a b)`         | `(or a b)`           | `(not a)`
| Shell           | `a && b`            | `a \|\| b`           | `!a`
| Standard ML     | `a andalso b`       | `a orelse b`         | `not a`

##### Bitwise Operators

| Language\Op     | and               | or                | xor                  | not            | notes
| --------------- | ----------------- | ----------------- | -------------------- | -------------- | -----
| C               | `a & b`           | `a \| b`          | `a ^ b`              | `~a`
| Clojure         | `(bit-and a b)`   | `(bit-or a b)`    | `(bit-xor a b)`      | `(bit-not a)`
| Common Lisp     | `(logand a b)`    | `(logior a b)`    | `(logxor a b)`       | `(lognot a)`
| Crystal         | `a & b`           | `a \| b`          | `a ^ b`              | `~a`
| D               | `a & b`           | `a \| b`          | `a ^ b`              | `~a`
| Haskell         | `a .&. b`         | `a .\|. b`        | `xor a b`            | `complement a` | `import Data.Bits`
| JavaScript      | `a & b`           | `a \| b`          | `a ^ b`              | `~a`
| Julia           | `a & b`           | `a \| b`          | `a ⊻ b`, `xor(a, b)` | `~a`
| Lua             | `a & b`           | `a \| b`          | `a ~ b`              | `~a`
| Nim             | `a and b`         | `a or b`          | `a xor b`            | `not a`
| Prolog          | `a /\ b`          | `a \/ b`          | `a xor b`            | `\ a`
| Python          | `a & b`           | `a \| b`          | `a ^ b`              | `~a`
| Ruby            | `a & b`           | `a \| b`          | `a ^ b`              | `~a`
| Scheme          | `(logand a b)`    | `(logior a b)`    | `(logxor a b)`       | `(lognot a)`
| Standard ML     | `Word.andb(a, b)` | `Word.orb(a, b)`  | `Word.xorb(a, b)`    | `Word.notb(a)` | `a` and `b` must be converted to [Words](https://smlfamily.github.io/Basis/word.html), i.e. `Word.fromInt(a)`

##### Bitshift Operators

| Language\Op     | left                   | right signed            | right unsigned
| --------------- | ---------------------- | ----------------------- | --------------
| C               | `a << b`               |                         | `a >> b`
| Clojure         | `(bit-shift-left a b)` | `(bit-shift-right a b)` | `(unsigned-bit-shift-right a b)`
| Common Lisp     | `(ash a b)`            | `(ash a (- b))`
| Crystal         | `a << b`               | `a >> b`
| Haskell         | `shift a b`            | `shift a (-b)`
| JavaScript      | `a << b`               | `a >> b`                | `a >>> b`
| Julia           | `a << b`               | `a >> b`                | `a >>> b`
| Lua             | `a << b`               |                         | `a >> b`
| Nim             | `a shl b`              | `a shr b`, `ashr(a, b)`
| Prolog          | `a << b`               | `a >> b`
| Python          | `a << b`               | `a >> b`
| Ruby            | `a << b`               | `a >> b`
| Scheme          | `(ash a b)`            | `(ash a (- b))`
| Standard ML     | `Word.<<(a, b)`        | `Word.~>>(a, b)`        | `Word.>>(a, b)`

###### Lua Bitshift

```lua
--- Signed bitshift right
---@param a integer
---@param b integer
function sar(a, b)
    return (a >> b) | (a & 0x8000000000000000)
end
```

###### Python Bitshift

```python
def shr(a, b: int):
    "Unsigned bitshift right"
    return (a >> b) & 0x7fffffffffffffff
```

###### Crystal & Ruby Bitshift

```ruby
##
# Unsigned bitshift right
def shr(a, b)
    return (a >> b) & 0x7fffffffffffffff
end
```

#### Variables

Languages are assumed to be lexically scoped, with implicitly declared local
scopes in function declarations and implicit local scoping of declarations
unless otherwise stated.

##### Variable Declaration

|                 | Variable        | Constant           | Comptime Const | Hoisted
| --------------- | --------------- | ------------------ | -------------- | -------
| Awk             | `x`
| C               | `T x;`          | `const T x = y;`   | `#define x y`
| Clojure         | `(let [x y])`   |
| Common Lisp     | `(defvar x)`    |
| Crystal         | `x`             | `X`
| Haskell         |                 | `let x = y`
| JavaScript      | `let x`         | `const x = y`      |                | `x`, `var x`
| Julia           | `x`, `local x`  | `const x = y`
| Lua             | `x`, `local x`  | `local x <const> = y`
| Nim             | `var x: T`      | `let x = y`        | `const x = y`
| Prolog          | `X`
| Python          | `x`
| Ruby            | `x`
| Scheme          | `(let (x y))`
| Shell           | `x=y`
| Standard ML     |                 | `val x = y;`

###### Scoping: Awk

All variables are globally scoped and implicitly declared. In functions, the
convention is to declare additional parameters to use as local variables.

```awk
function doSomething(x, y,             a, b, c) {
    # x and y are params
    # a, b and c are local variables
}
```

###### Scoping: C

In ANSI C, all variables must be declared at the beginning of the function, but
this restriction is loosened in later C standards.

###### Const: C

In C, `const` is a type descriptor, rather than a keyword introducing a
variable declaration.

###### Scoping: JavaScript

The `var` keyword in JavaScript declares a hoisted variable. Hoisted variable
are implicitly moved to the beginning of the variable's scope, and can be
referred to before their declaration. The `let` and `const` keywords were
introduced in ES6, which have block scoping.

###### Scoping: Julia

Julia's has [global and local lexical scoping](https://docs.julialang.org/en/v1/manual/variables-and-scoping/#scope-of-variables). Global scoping works different
from other languages, in that declaring a module introduces a new global scope.

The top-level global scope is actually the scope of the Main module, all other
modules are created within the Main module's global scope. Modules can be
declared inside other modules, but not inside local scopes, which means that
a local scope can be nested in a local scope or a global scope, but a global
scope can only be nested in another global scope. The `global` keyword can be
used to declare a variable in the innermost module scope which contains the
declaration.

Functions, `do` and `let` blocks, generators and comprehensions introduce a new
local scope, and any variable declaration within it is implicitly local.
`begin` blocks also introduce a new scope, but declarations within it are
implicitly global, the `local` keyword must be used to scope a variable to a
`begin` block.

###### Scoping: Lua

Functions, `do`, `while`, `for` and `repeat` blocks all introduce a new local
scope. [Variables are implicitly global](https://www.lua.org/manual/5.4/manual.html#3.5),
and the `local` keyword must be used to locally scope a variable.

#### List Operations

| Language\Op     | Literal syntax         | List comparison       | `==` empty list
| --------------- | ---------------------- | --------------------- | ---------------
| C               | `{1, 2, 3}`            |                       | `NULL`
| Clojure         | `'(1 2 3)`, `[1 2 3]`  | `=`                   | `nil` `()` `[]`
| Common Lisp     | `'(1 2 3)`             | `equalp`              | `nil` `()`
| Haskell         | `[1, 2, 3]`            | `==`                  | `[]`
| JavaScript      | `[1, 2, 3]`            |                       | `[]` `0` `false` `''`
| Julia           | `[1, 2, 3]`            | `==`                  | `[]`
| Lua             | `{ 1, 2, 3 }`
| Nim             | `[1, 2, 3]`            | `==`                  | `[]`
| Python          | `[1, 2, 3]`            | `==`                  | `[]`
| Ruby            | `[1, 2, 3]`            | `==`                  | `[]`
| Scheme          | `'(1 2 3)`             | `eq?` `equal?`        | `'()`
| Shell           | `(1 2 3)`
| Standard ML     | `[1, 2, 3]`            | `=`                   | `[]` `nil`

##### JavaScript List Compare

```js
function listCompare(left, right) {
  if (Array.isArray(left) && Array.isArray(right) && left.length === right.length) {
    for (let i = 0; i < left.length; i++) {
      if (!listCompare(left[i], right[i])) {
        return false
      }
    }
    return true
  }
  return left === right
}
```

##### Lua List Compare

```lua
local function list_compare(left, right)
    if type(left) == "table" and type(right) == "table" and #left == #right then
        for i = 1, #left do
            if not list_compare(left[i], right[i]) then
                return false
            end
        end
        return true
    end
    return left == right
end
```

- pushfirst `([y, z], x) -> [x, y, z]`
- popfirst `(([y, z]) -> y)`
- push `([y, z], x) -> [y, z, x]`
- pop `(([y, z]) -> z)`

| Language\Op     | pushfirst                | popfirst              | push                  | pop
| --------------- | ------------------------ | --------------------- | --------------------- | ---
| Clojure         | `(cons x xs)`            | `(first xs)`
| Common Lisp     | `(cons x xs)`            | `(car xs)`
| Haskell         | `x : xs`                 |
| JavaScript      | `xs.unshift(x)`          | `xs.shift()`          | `xs.push(x)`          | `xs.pop()`
| Julia           | `pushfirst!(xs, x)`      | `popfirst!(xs)`       | `push!(xs, x)`        | `pop!(xs)`
| Lua             | `table.insert(xs, 1, x)` | `table.remove(xs, 1)` | `table.insert(xs, x)` | `table.remove(xs)`
| Nim             |
| Python          | `xs.insert(0, x)`        |                       | `xs.append(x)`        | `xs.pop()`
| Ruby            | `xs.unshift(x)`          | `xs.shift()`          | `xs.push(x)`          | `xs.pop()`
| Scheme          | `(cons x xs)`            | `(car xs)`
| Standard ML     | `x :: xs`                |                       | `xs @ [x]`

#### Errors

Each code snippet shows off features which are available to the language.
Documents:

- Terminology for throwing/raising/yeeting errors/exceptions/oopsydoodles.
- Catching only specific error types, if possible
- Rethrowing caught errors without ruining the stack trace
- `assert` functionality, if any
- Whether the default message on assertions is of any use in figuring out which assertion failed

##### JavaScript Errors

- [mdn Error object](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error#examples)
- [Deno assert docs](https://deno.land/std@0.183.0/testing/asserts.ts?doc=)

```js
try {
    throw new Error(msg)
} catch (error) {
    if (error instanceof CustomError) {
        // handle error type...
    } else {
        throw error // rethrow
    }
} finally {
    // ...
}

// node has `assert` preloaded, for deno and browser
import { assert } from 'https://deno.land/std/testing/asserts.ts'
assert(1 === 1, 'Default message useless')
```

##### Julia Errors

```julia
try
    throw(ErrorException(msg))
catch error
    rethrow()
finally
    # ...
end

@assert 1 == 1 "Default message useful"
```

##### Lua Errors

- [Error Handling in Lua](https://www.lua.org/manual/5.4/manual.html#2.3)

```lua
function f() error(msg) end
local success, result = pcall(f, ...)
if success then
    -- result is value returned by f(...)
else
    -- result is error message
    error(result)
end
```

##### Nim Errors

- [Nim Manual: Exception Handling](https://nim-lang.org/docs/manual.html#exception-handling)
- [Nim Manual: system/assertions](https://nim-lang.org/docs/assertions.html)

```nim
try:
    raise newException(ValueError, msg)
except ValueError:
    let
        error = (ref ValueError)(getCurrentException())
        msg = getCurrentExceptionMsg()
    raise
except IOError as error:
    raise error
finally:
    # ...

# goes away with -d:danger or --assertions:off
assert(1 == 1, "Default message useful")
# can't be removed
doAssert(1 == 1, "Default message useful")

# bonus feature: defer

let f = open("path")
defer(close(f))
f.write("abc")

# equivalently...

let f = open("path")
try:
    f.write("abc")
finally:
    close(f)

```

##### Python Errors

```py
try:
    raise Exception(msg)
except (RuntimeError, TypeError, NameError):
    raise
except Exception as error:
    raise error
except:
    # ...
finally:
    # ...

assert 1 == 1, "Default message useless"
```

##### Ruby Errors

```ruby
begin
    raise msg
rescue ArgumentError, NameError
    raise # reraise
rescue EOFError => exception
    raise exception
rescue => exception
    retry
ensure
    # finally
end
```

#### Systems of Reuse

Languages have different methods of reusing generic methods defined on a type
hierarchy or prototype chain.

The most commonly encountered system is a class based single inheritance model.
With this model, each object is defined as a *class* which can *inherit*
features from a *parent* or *super* class.

##### JavaScript Classes and Prototypes

In early versions, JavaScript used a prototype chain for inheritance. When ES6
was released, a `class` keyword was added, which mimics the more commonly known
style of class based inheritance, but still uses the original prototype system
under the hood.

This makes it easy to write code in the class based style

##### Julia Structs and Multiple Dispatch

##### Lua Tables and Metatables

### Documentation

[Learn X in Y minutes](https://learnxinyminutes.com/) has good overviews of
syntax and basic idioms of all of the languages listed.

#### Awk Reference

- `man awk`, `info awk`

#### C Reference

- [Beej's Guide to C Programming](https://beej.us/guide/bgc/html/split/index.html)
- `man cc`

#### Clojure Reference

- [ClojureDocs](https://clojuredocs.org/)

#### Common Lisp Reference

- [Common Lisp HyperSpec](http://www.lispworks.com/documentation/HyperSpec/Front/index.htm)
- [Common Lisp Quick Reference](http://clqr.boundp.org/)

#### Crystal Reference

- [Crystal Reference](https://crystal-lang.org/reference)
- [Crystal Standard Library](https://crystal-lang.org/api)

#### D Reference

- [D Language Reference](https://dlang.org/spec/spec.html)
- [D Library Reference](https://dlang.org/phobos/index.html)

#### Haskell Reference

- [Haskell Hierarchical Libraries](https://downloads.haskell.org/ghc/latest/docs/libraries/)
- [Learn You A Haskell For Great Good!](http://learnyouahaskell.com/chapters)
- [The Haskell Wiki](https://wiki.haskell.org/Haskell)
- [Tour of the Haskell Syntax](https://cs.fit.edu/~ryan/cse4250/haskell-syntax.html)

#### JavaScript Reference

- [mdn](https://mdn.io)
- [ECMA-262 ECMAScript Language Specification](https://tc39.es/ecma262/)

#### Julia Reference

- [Julia Documentation](https://docs.julialang.org/en/v1/)

#### Lua Reference

- [Lua Reference Manual](https://www.lua.org/manual/5.4/manual.html)
- [Programming in Lua](https://www.lua.org/pil/contents.html)

#### Nim Reference

- [Nim Manual](https://nim-lang.org/docs/manual.html)
- [Nim by Example](https://nim-by-example.github.io/)

#### Prolog Reference

- [SWI-Prolog Summary](https://www.swi-prolog.org/pldoc/man?section=summary)

#### Python Reference

- [Python Docs](https://docs.python.org/3/)

#### Ruby Reference

- [Ruby Doc](https://ruby-doc.org/)

#### Scheme Reference

- [The Guile Reference Manual](https://www.gnu.org/software/guile/manual/html_node/index.html)

#### Shell Reference

- [The POSIX Shell And Utilities](https://shellhaters.org/)

#### Standard ML Reference

- [The Standard ML Basis Library](https://smlfamily.github.io/Basis/overview.html)
