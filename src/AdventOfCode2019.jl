module AdventOfCode2019

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

end # module
