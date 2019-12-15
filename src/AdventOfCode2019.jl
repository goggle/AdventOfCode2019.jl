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
    for day in 1:25
        sym = Symbol("day" * @sprintf("%02d", day))
        !isdefined(@__MODULE__, sym) && continue
        #f = getproperty(AdventOfCode2019, sym)
        f = getproperty(@__MODULE__, sym)
    end
end

end # module
