module Day09

using AdventOfCode2019

function day09(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    program = parse.(BigInt, split(input, ","))
    channelIn = Channel{BigInt}(1)
    put!(channelIn, BigInt(1))
    out1 = AdventOfCode2019.Day05._run_program(program, channelIn, nothing, nothing)
    close(channelIn)

    channelIn = Channel{BigInt}(2)
    out2 = AdventOfCode2019.Day05._run_program(program, channelIn, nothing, nothing)
    close(channelIn)
    return [out1[end], out2[end]]
end

end # module
