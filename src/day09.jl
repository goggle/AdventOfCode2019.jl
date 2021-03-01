module Day09

using AdventOfCode2019

function day09(input::String = readInput(joinpath(@__DIR__, "..", "data", "day09.txt")))
    program = parse.(Int, split(input, ","))
    channelIn = Channel{Int}(1)
    put!(channelIn, Int(1))
    out1 = AdventOfCode2019.IntCode.run_program!(program, channelIn, nothing, nothing)
    close(channelIn)

    channelIn = Channel{Int}(2)
    put!(channelIn, Int(2))
    out2 = AdventOfCode2019.IntCode.run_program!(program, channelIn, nothing, nothing)
    close(channelIn)
    return [out1[end], out2[end]]
end

end # module
