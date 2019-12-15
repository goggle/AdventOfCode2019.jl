module AdventOfCode2019

using BenchmarkTools
using Printf

const solvedDays = 1:14

include(joinpath(@__DIR__, "intcode.jl"))
for day in solvedDays
    ds = @sprintf("%02d", day)
    include(joinpath(@__DIR__, "day$ds", "day$ds.jl"))
end

export readInput
function readInput(path::String)
    s = open(path, "r") do file
        read(file, String)
    end
    return s
end

for d in solvedDays
    global ds = @sprintf("day%02d", d)
    global modSymbol = Symbol(@sprintf("Day%02d", d))
    global dsSymbol = Symbol(@sprintf("day%02d", d))
    @eval begin
        function $dsSymbol(input::String = readInput(joinpath(@__DIR__, $ds, "input.txt")))
            return AdventOfCode2019.$modSymbol.$dsSymbol(input)
        end
        export $dsSymbol
    end
end

function benchmark()
    results = []
    for day in solvedDays
        ds = @sprintf("day%02d", day)
        global input = readInput(joinpath(@__DIR__, ds, "input.txt"))
        # println(input)
        dsSymbol = Symbol(@sprintf("day%02d", day))
        global func = eval(dsSymbol)
        bresult = @benchmark(func($input))
        push!(results, (day, time(bresult), memory(bresult)))
    end
    return results
end

function _to_markdown_table(bresults)
    header = "| Day | Time | Memory |\n" *
             "|----:|-----:|-------:|"
    lines = [header]
    for (d, t, m) in bresults
        ds = string(d)
        ts = BenchmarkTools.prettytime(t)
        ms = BenchmarkTools.prettymemory(m)
        push!(lines, "| $ds | $ts | $ms |")
    end
    return join(lines, "\n")
end

end # module
