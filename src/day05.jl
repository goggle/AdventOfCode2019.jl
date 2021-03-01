module Day05

using AdventOfCode2019

function day05(input::String = readInput(joinpath(@__DIR__, "..", "data", "day05.txt")))
    data = parse.(Int, split(input, ","))

    c1 = Channel{Int}(2)
    put!(c1, 1)
    out1 = AdventOfCode2019.IntCode.run_program!(copy(data), c1, nothing, nothing)
    close(c1)

    c2 = Channel{Int}(2)
    put!(c2, 5)
    out2 = AdventOfCode2019.IntCode.run_program!(copy(data), c2, nothing, nothing)
    close(c2)

    return [out1[end], out2[end]]
end

end # module
