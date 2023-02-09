#!/usr/bin/env julia

paths = isempty(ARGS) ? ("hello-world", "brainfuck") : ARGS

eachlang(path::AbstractString) = split(basename(path), r"[_.]")

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
        elseif lang == "c"
            push!(cmds, `cc -o tmp/$(name) $(file)`, `tmp/$(name) $(inputfile)`)
        elseif lang == "jl"
            push!(cmds, `julia $(file)  $(inputfile)`)
        elseif lang == "js"
            push!(cmds, `node $(file) $(inputfile)`, `deno run $(file) $(inputfile)`, `qjs $(file) $(inputfile)`)
        elseif lang == "lisp"
            push!(cmds, `sbcl --script $(file) $(inputfile)`)
        elseif lang == "lua"
            push!(cmds, `lua $(file) $(inputfile)`)
        elseif lang == "py"
            push!(cmds, `python3 $(file) $(inputfile)`)
        elseif lang == "rb"
            push!(cmds, `ruby $(file) $(inputfile)`)
        elseif lang == "sh"
            push!(cmds, `sh $(file)`)
        elseif lang == "sml"
            push!(cmds, `mlton -output tmp/$(name) $(file)`, `tmp/$(name) $(inputfile)`)
        else
            push!(cmds, `true`)
        end
    end
    cmds
end

for path in paths
    for (rootname, _, files) in walkdir(path)
        printstyled("\n\nTesting $(rootname)\n"; bold=true)
        for file in files
            println("\n", file)
            run.(tocmd("$(rootname)/$(file)"))
        end
    end
end
