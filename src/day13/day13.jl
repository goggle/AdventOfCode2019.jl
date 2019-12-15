module Day13

using AdventOfCode2019

function day13(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    program = parse.(Int, split(input, ","))
    output = AdventOfCode2019.IntCode.run_program!(copy(program), nothing, nothing, nothing)
    part1 = sum(output[3:3:length(output)] .== 2)

    part2 = _play_game(program)
    return [part1, part2]
end

function _play_game(program::Array{Int,1})
    program[1] = 2
    input = Channel{Int}(10)
    output = Channel{Int}(10)
    t = @task AdventOfCode2019.IntCode.run_program!(copy(program), input, output, nothing)
    schedule(t)

    currentScore = 0
    paddlePos = (-1, 0)
    ballPos = (-1, 0)
    while !istaskdone(t)
        x = take!(output)
        y = take!(output)
        id = take!(output)
        if id == 4
            ballPos = (x, y)
            if ballPos[1] < paddlePos[1]
                put!(input, -1)
            elseif ballPos[1] > paddlePos[1]
                put!(input, 1)
            else
                put!(input, 0)
            end
        elseif id == 3
            paddlePos = (x, y)
        end

        if x == -1 && y == 0
            currentScore = id
        end
    end
    close(input)
    close(output)
    return currentScore
end

end # module
