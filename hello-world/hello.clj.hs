#!/usr/bin/env runghc
{- *}; code visible to Clojure

(println "Hello from Clojure!")

(comment; code visible to Haskell -}

println = putStrLn
main = do
    println "Hello from Haskell!"

-- code visible to Clojure and Haskell )

    (println "Hello from Clojure and Haskell!")
