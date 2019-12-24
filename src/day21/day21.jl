module Day21

using AdventOfCode2019

function day21(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    program = parse.(Int, split(input, ','))

    # logic: (¬A || ¬B || ¬C) && D
    instructionsPart1 = [
        "NOT A T",
        "NOT B J",
        "OR T J",
        "NOT C T",
        "OR T J",
        "AND D J",
        "WALK\n",
    ]

    # logic: (¬A || ¬B || (¬C && H)) && D
    instructionsPart2 = [
        "NOT A T",
        "NOT B J",
        "OR T J",
        "NOT C T",
        "AND H T",
        "OR T J",
        "AND D J",
        "RUN\n",
    ]

    p1 = run(program, instructionsPart1)
    p2 = run(program, instructionsPart2)

    return [p1, p2]
end

function run(program::Array{Int,1}, instructions)
    ascii = [Int(x) for x in join(instructions, "\n")]
    inp = Channel{Int}(100)
    out = Channel{Int}(1)

    t = @async AdventOfCode2019.IntCode.run_program!(copy(program), inp, out, nothing)
    for a in ascii
        put!(inp, a)
    end
    val = 0
    while !istaskdone(t)
        val = take!(out)
    end
    close(inp)
    close(out)
    return val
end

end # module
