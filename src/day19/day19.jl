module Day19

using AdventOfCode2019

function day19(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    program = parse.(Int, split(input, ','))

    p1 = part1(program)
    p2 = part2(program)
    return [p1, p2]

end

function part1(program::Array{Int,1})
    inp = Channel{Int}(2)
    out = Channel{Int}(1)

    count = 0
    for x = 0:49
        for y = 0:49
            @async AdventOfCode2019.IntCode.run_program!(copy(program), inp, out, nothing)
            put!(inp, x)
            put!(inp, y)
            val = take!(out)
            count += val
        end
    end
    close(inp)
    close(out)
    return count
end

function part2(program::Array{Int,1})
    inp = Channel{Int}(2)
    out = Channel{Int}(1)

    x = 30
    y = 0
    ysave = 0

    while true
        @label start
        while !in_beam(program, inp, out, x, y)
            y += 1
        end
        first = true
        while in_beam(program, inp, out, x, y)
            if first
                ysave = y
                first = false
            end
            if !in_beam(program, inp, out, x, y + 99)
                y = ysave
                x += 1
                @goto start
            end
            if in_beam(program, inp, out, x + 99, y)
                in_beam(program, inp, out, x + 99, y + 99) || throw(AssertionError("Not a tractor beam"))
                close(inp)
                close(out)
                return 10_000 * x + y
            end
            y += 1
        end
    end
end

function in_beam(program::Array{Int,1}, inp::Channel{Int}, out::Channel{Int}, x::Int, y::Int)
    @async AdventOfCode2019.IntCode.run_program!(copy(program), inp, out, nothing)
    put!(inp, x)
    put!(inp, y)
    take!(out) == 1 && return true
    return false
end

end # module
