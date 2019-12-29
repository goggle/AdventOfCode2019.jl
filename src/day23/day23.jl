module Day23

using AdventOfCode2019

function day23(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    program = parse.(Int, split(input, ','))
    part1(program)

end

function part1(program::Array{Int,1})
    inps = [Channel{Int}(1) for i = 1:50]
    outs = [Channel{Int}(1) for i = 1:50]
    for i = 0:49
        @async AdventOfCode2019.IntCode.run_program!(copy(program), inps[i+1], outs[i+1], nothing)
        put!(inps[i+1], i)
    end
end

function connect(inps, outs)
    while true
    end
end


end # module
