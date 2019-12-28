module Day22

using AdventOfCode2019

function day22(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    instructions = parse_instructions(input)
    p1 = part1(instructions)
    p2 = part2(instructions)
    return [p1, p2]
end

function part1(instructions)
    n = 10_006
    i = 2019
    for (inst, N) in instructions
        if inst == :stack
            i = n - i
        elseif inst == :cut
            i = mod(i - N, n + 1)
        elseif inst == :increment
            i = mod(i * N, n + 1)
        end
    end
    return i
end

function part2(instructions)
    i = 5540
    niter = 1
    n = 10_006

    i = BigInt(2020)
    n = BigInt(119_315_717_514_047) - 1
    niter = BigInt(101_741_582_076_661)

    x = i
    y = apply_reverse_instructions(instructions, x, n + 1)
    z = apply_reverse_instructions(instructions, y, n + 1)
    a = mod((y - z) * invmod(x - y, n + 1), n + 1)
    b = mod(y - a * x, n + 1)

    pm = powermod(a, niter, n + 1)
    c = mod(mod(pm - 1, n + 1) * invmod(a - 1, n + 1), n + 1)
    i = mod(pm * i + b * c, n + 1)

    return i
end

function apply_reverse_instructions(instructions, i, decksize)
    n = decksize - 1
    for (inst, N) in reverse(instructions)
        if inst == :stack
            i = n - i
        elseif inst == :cut
            i = mod(i + N, n + 1)
        elseif inst == :increment
            i = mod(invmod(N, n + 1) * i, n + 1)
        end
    end
    return i
end

function parse_instructions(input::String)
    instructions = Array{Tuple{Symbol,Union{Int,Nothing}},1}()
    newStackRegex = r"deal\sinto\snew\sstack"
    cutRegex = r"cut\s(-?[0-9]+)"
    incrementRegex = r"deal\swith\sincrement\s([0-9]+)"
    for line in split(strip(input), "\n")
        m = match(newStackRegex, line)
        if !isa(m, Nothing)
            push!(instructions, (:stack, nothing))
            continue
        end
        m = match(cutRegex, line)
        if !isa(m, Nothing)
            val = parse(Int, m.captures[1])
            push!(instructions, (:cut, val))
            continue
        end
        m = match(incrementRegex, line)
        if !isa(m, Nothing)
            val = parse(Int, m.captures[1])
            push!(instructions, (:increment, val))
            continue
        end
    end
    return instructions
end

end # module
