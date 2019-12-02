function day01(input::String = readInput(inputPath("day01.txt")))
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
