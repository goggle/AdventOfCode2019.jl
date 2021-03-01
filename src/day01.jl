module Day01

using AdventOfCode2019

function day01(input::String = readInput(joinpath(@__DIR__, "..", "data", "day01.txt")))
    masses = parse.(Int, split(input))
    fuel = masses .÷ 3 .- 2

    solution2 = 0
    for elem in fuel
        while elem > 0
            solution2 += elem
            elem = elem ÷ 3 - 2
        end
    end

    return [fuel |> sum, solution2]
end

end # module
