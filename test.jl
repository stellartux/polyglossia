#!/usr/bin/env julia

paths = isempty(ARGS) ? ("hello-world", "brainfuck") : ARGS

eachlang(path::AbstractString) = split(basename(path), r"[_.]")

filecontains(filepath, needle) = contains(read(filepath, String), needle)

inputfiles = Dict(
    "hello-world" => "",
    "brainfuck" => "brainfuck/hello.bf"
)

function tocmd(file)
    name, langs... = eachlang(file)
    inputfile = inputfiles[basename(dirname(file))]
    cmds = Cmd[]
    for lang in langs
        if lang == "awk"
            push!(cmds, `gawk -f $(file) $(inputfile)`)
        elseif lang == "c" || lang == "sml" || (lang == "lisp" && filecontains(file, "defun main"))
            push!(cmds, `make -s o/$(file).$(lang)_compiled`, `o/$(file).$(lang)_compiled $(inputfile)`)
        elseif lang == "hs"
            push!(cmds, `runghc $(file)`)
        elseif lang == "jl"
            push!(cmds, `julia $(file) $(inputfile)`)
        elseif lang == "js"
            push!(cmds,
                `node $(file) $(inputfile)`,
                `deno run $(file) $(inputfile)`,
                `qjs $(file) $(inputfile)`,
                `guile --no-debug --language ecmascript -s $(file) $(inputfile)`)
        elseif lang == "lisp"
            push!(cmds, `sbcl --script $(file) $(inputfile)`)
        elseif lang == "lua"
            push!(cmds, `lua $(file) $(inputfile)`)
        elseif lang == "py"
            push!(cmds, `python3 $(file) $(inputfile)`)
        elseif lang == "rb"
            push!(cmds, `ruby $(file) $(inputfile)`)
        elseif lang == "scm"
            push!(cmds,
                if filecontains(file, "(define (main")
                    `guile --no-debug -e main -s $(file) $(inputfile)`
                else
                    `guile --no-debug -s $(file) $(inputfile)`
                end)
        elseif lang == "sh"
            push!(cmds, `sh --posix $(file)`)
        else
            println("Don't know what to do with $(lang)")
        end
    end
    cmds
end

function testfile(file, rootname=".")
    println("\n", file)
    Threads.@threads for cmd in tocmd("$(rootname)/$(file)")
        run(cmd)
    end
end

for path in paths
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
