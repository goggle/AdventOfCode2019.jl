module AdventOfCode2019

using BenchmarkTools
using Printf

include(joinpath(@__DIR__, "day01", "day01.jl"))
include(joinpath(@__DIR__, "day02", "day02.jl"))
include(joinpath(@__DIR__, "day03", "day03.jl"))
include(joinpath(@__DIR__, "day04", "day04.jl"))
include(joinpath(@__DIR__, "day05", "day05.jl"))
include(joinpath(@__DIR__, "day06", "day06.jl"))
include(joinpath(@__DIR__, "day07", "day07.jl"))
include(joinpath(@__DIR__, "day08", "day08.jl"))
include(joinpath(@__DIR__, "day09", "day09.jl"))
include(joinpath(@__DIR__, "day10", "day10.jl"))
include(joinpath(@__DIR__, "day11", "day11.jl"))

export readInput
function readInput(path::String)
    s = open(path, "r") do file
        read(file, String)
    end
    return s
end

function inputPath(fname::String)
    return joinpath(splitpath(@__DIR__)[1:end-1]..., "data", fname)
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
