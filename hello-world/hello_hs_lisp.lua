;--[[
;{- Code visible to Common Lisp

(defun putStrLn (x) (princ x) (terpri))
(putStrLn "Hello from Common Lisp!")

#| Code visible to Lua ]]

local function void(...) end
local function putStrLn(...) print(...) return void end
putStrLn("Hello from Lua!")

--[[ Code visible to Haskell -}

main = do
    putStrLn "Hello from Haskell!"

-- Code visible to Common Lisp, Haskell and Lua ]]--|#
    (putStrLn "Hello from Common Lisp, Haskell and Lua!")
