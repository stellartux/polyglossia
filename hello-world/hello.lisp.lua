#!/usr/bin/env lua
;--[[ Code visible to Common Lisp

(defun println (x) (princ x) (princ #\Newline) nil)
(println "Hello from Common Lisp!")

#|| Code visible to Lua ]]

function void(...) end
function println(...) print(...) return void end
println("Hello from Lua!")

-- Code visible to Common Lisp and Lua ||#

(println "Hello from Common Lisp and Lua!")
