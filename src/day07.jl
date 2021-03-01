module Day07

using AdventOfCode2019
using Combinatorics

function day07(input::String = readInput(joinpath(@__DIR__, "..", "data", "day07.txt")))
    program = parse.(Int, split(input, ","))

    maxOut1 = maximum(run_amplifiers(copy(program), phases, 0) for phases in permutations([0, 1, 2, 3, 4]))
    maxOut2 = maximum(run_feedback_loop(copy(program), phases, 0) for phases in permutations([5, 6, 7, 8, 9]))
    return [maxOut1, maxOut2]
end

function run_amplifiers(program::Array{Int,1}, phases::Array{Int,1}, inputA::Int)
    channels = [Channel{Int}(10) for i = 1:6]
    for i = 1:5
        put!(channels[i], phases[i])
    end
    put!(channels[1], inputA)

    for i = 1:5
        @async AdventOfCode2019.IntCode.run_program!(copy(program), channels[i], channels[i+1], nothing)
    end
    result = take!(channels[6])
    for i = 1:6
        close(channels[i])
    end
    return result
end

function run_feedback_loop(program::Array{Int,1}, phases::Array{Int,1}, inputA::Int)
    channels = [Channel{Int}(10) for i = 1:5]
    status = [Channel{Bool}(1) for i = 1:5]
    for i = 1:5
        put!(channels[i], phases[i])
    end
    put!(channels[1], inputA)

    for i = 1:5
        @async AdventOfCode2019.IntCode.run_program!(copy(program), channels[i], channels[mod1(i+1, 5)], status[i])
    end
    for i = 1:5
        take!(status[i])
    end

    result = take!(channels[1])
    for i = 1:5
        close(channels[i])
        close(status[i])
    end
    return result
end

end # module
