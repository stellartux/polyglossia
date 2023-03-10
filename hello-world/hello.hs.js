{-0;} // code visible to JavaScript

var putStrLn;
if (this == undefined) {
  putStrLn = console.log;
  putStrLn("Hello from \x1b[33mdeno\x1b[m!");
} else if (this.print) {
  putStrLn = print;
  putStrLn("Hello from \x1b[33mqjs\x1b[m!");
} else if (this.display) {
  this.console = { log: putStrLn = function(s) { display(s); newline(); }};
  putStrLn("Hello from \x1b[33mguile\x1b[m!");
} else {
  putStrLn = console.log;
  putStrLn("Hello from \x1b[33mnode\x1b[m!");
}

/* code visible to Haskell -}

main = do
  putStrLn "Hello from \x1b[95mHaskell\x1b[m!"

-- code visible to Haskell and JavaScript */

  putStrLn("Hello from \x1b[95mHaskell\x1b[m and \x1b[33mJavaScript\x1b[m!");
