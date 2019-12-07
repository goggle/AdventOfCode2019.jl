module Day02

using AdventOfCode2019

function day02(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    data = parse.(Int, split(input, ","))
    dataCopy = copy(data)

    data[1+1] = 12
    data[2+1] = 2
    part1 = _run_program(data)

    copy!(data, dataCopy)
    part2 = 0
    for noun = 0:99
        for verb = 0:99
            copy!(data, dataCopy)
            data[2] = noun
            data[3] = verb
            result = _run_program(data)
            if result == 19690720
                part2 = 100 * noun + verb
            end
        end
    end
    return [part1, part2]
end

function _run_program(data::Array{Int, 1})
    for i = 1:4:length(data)
        optcode = data[i]
        if optcode == 99
            break
        elseif optcode == 1 || optcode == 2
            pos1 = data[i+1] + 1
            pos2 = data[i+2] + 1
            pos3 = data[i+3] + 1
            if optcode == 1
                data[pos3] = data[pos1] + data[pos2]
            elseif optcode == 2
                data[pos3] = data[pos1] * data[pos2]
            end
        else
            println("Invalid optcode")
            break
        end
    end
    return data[1]
end

end # module
