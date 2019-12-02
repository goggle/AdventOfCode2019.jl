module AdventOfCode2019

files = [x for x in readdir(joinpath(@__DIR__, "days")) if splitext(x)[2]==".jl"]
include.(joinpath.(@__DIR__, "days", files))

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
