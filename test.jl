#!/usr/bin/env julia

module PolyglossiaTests

eachlang(path::AbstractString) = split(basename(path), r"[_.]")

filecontains(filepath, needle::AbstractString) =
    contains(read(filepath, String), needle)

function filecontains(filepath, needles...)
    file = read(filepath, String)
    tuple((contains(file, needle) for needle in needles)...)
end

inputfiles = Dict(
    "brainfuck" => "brainfuck/hello.bf",
    "edit-distance" => ("levenshteins", "runningtime")
)

function tocmd(file)
    name, langs... = eachlang(file)
    inputfile = get(inputfiles, basename(dirname(file)), "")
    cmds = []
    for lang in langs
        if lang == "awk"
            push!(cmds, `gawk -f $(file) $(inputfile)`)
        elseif lang == "c" || lang == "d" || lang == "nim" || lang == "sml" || (lang == "lisp" && filecontains(file, "defun main"))
            push!(cmds, `make -s o/$(file).$(lang)_compiled`, `o/$(file).$(lang)_compiled $(inputfile)`)
        elseif lang == "clj"
            push!(cmds, `clojure -M $(file)`)
        elseif lang == "hs"
            push!(cmds, `runghc $(file)`)
        elseif lang == "jl"
            push!(cmds, `julia $(file) $(inputfile)`)
        elseif lang == "js"
            deno, node, qjs, guile = filecontains(file, "deno", "node", "qjs", "guile")
            if deno
                push!(cmds, `deno run $(file) $(inputfile)`)
            end
            if node
                push!(cmds, `node $(file) $(inputfile)`)
            end
            if qjs
                push!(cmds, `qjs $(file) $(inputfile)`)
            end
            if guile
                push!(cmds, `guile --no-debug --language ecmascript -s $(file) $(inputfile)`)
            end
        elseif lang == "lisp"
            push!(cmds, `sbcl --script $(file) $(inputfile)`)
        elseif lang == "lua"
            push!(cmds, `lua $(file) $(inputfile)`)
        elseif lang == "nims"
            push!(cmds, `nim run $(file) $(inputfile)`)
        elseif lang == "pl"
            push!(cmds, `swipl $(file) $(inputfile)`)
        elseif lang == "py"
            push!(cmds, `python3 $(file) $(inputfile)`)
        elseif lang == "rb"
            push!(cmds, `ruby $(file) $(inputfile)`)
        elseif lang == "scm"
            push!(cmds,
                if filecontains(file, "(define (main")
                    `guile --no-auto-compile --no-debug -e main -s $(file) $(inputfile)`
                else
                    `guile --no-auto-compile --no-debug -s $(file) $(inputfile)`
                end)
        elseif lang == "sh"
            push!(cmds, `sh --posix $(file)`)
        else
            println("Skipping $(lang)")
        end
    end
    cmds
end

function testfile(file, rootname=".")
    printstyled("\n[", file, "]\n"; color=:black)
    Threads.@threads for cmd in tocmd("$(rootname)/$(file)")
        run(pipeline(cmd; stderr=devnull))
    end
end

function runtest(path::AbstractString)
    if isdir(path)
        for (rootname, _, files) in walkdir(path)
            printstyled("\n\nTesting $(rootname)\n"; bold=true)
            for file in files
                if !endswith(file, ".md")
                    testfile(file, rootname)
                end
            end
        end
    elseif isfile(path)
        testfile(path)
    else
        error("Invalid path: $path")
    end
end

"""

    runtest(paths...)

Execute each polyglot language file in each of the given paths in each language.
"""
runtest(paths) = foreach(runtest, paths)
runtest(paths...) = foreach(runtest, paths)
runtest() = runtest("hello-world", "brainfuck")

if abspath(PROGRAM_FILE) == @__FILE__
    runtest(ARGS...)
end
export runtest

end#module
