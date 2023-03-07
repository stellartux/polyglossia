#!/usr/bin/env julia
#| Code visible to Julia

macro putStrLn_str(s)
    :(println($(s)))
end
putStrLn"Hello from Julia!"

#= Code visible to Common Lisp |#
(defun putStrLn (x) (princ x) (terpri))
(putStrLn "Hello from Common Lisp!")

; Code visible to Common Lisp and Julia =#
(putStrLn"Hello from Common Lisp and Julia!")
