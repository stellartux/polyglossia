#!/usr/bin/env -S guile -s
# Code visible to Julia

macro putStrLn_str(s)
    :(println($(s)))
end
putStrLn"Hello from Julia!"

#= Code visible to Scheme !#

(define (putStrLn x) (display x) (newline))
(putStrLn "Hello from Scheme!")

; Code visible to Julia and Scheme =#

(putStrLn"Hello from Julia and Scheme!")
