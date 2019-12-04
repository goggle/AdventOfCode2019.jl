module AdventOfCode2019

using BenchmarkTools
using Printf

include(joinpath(@__DIR__, "day01", "day01.jl"))
include(joinpath(@__DIR__, "day02", "day02.jl"))
include(joinpath(@__DIR__, "day03", "day03.jl"))

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
        !isdefined(AdventOfCode2019, sym) && continue
        func = getproperty(AdventOfCode2019, sym)
        @btime AdventOfCode2019.func()
    end
end

end # module
