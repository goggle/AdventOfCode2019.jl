module Day22

using AdventOfCode2019

function day22(input::String = readInput(joinpath(@__DIR__, "..", "data", "day22.txt")))
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
    i = BigInt(2020)
    n = BigInt(119_315_717_514_047) - 1
    niter = BigInt(101_741_582_076_661)

    # Observation: every single shuffle instruction from the input
    # can be represented as `g(i) = a*i + b (modulo n + 1)`, so
    # the result of applying all the shuffle instructions from the
    # input can also be represented as `f(i) = a*i + b (modulo n + 1)`.
    # We need to find the integers `a` and `b`. Set `x = i`, `y = f(x)`
    # and `z = f(y)`. Then `y = a*x + b` and `z = a*y + b`,
    # so `a = (x - y)^{-1} * (y - z) (modulo n + 1)` where
    # `(x - y)^{-1}` is the modular inverse and `b = y - a*x (modulo n + 1)`
    x = i
    y = apply_reverse_instructions(instructions, x, n + 1)
    z = apply_reverse_instructions(instructions, y, n + 1)
    a = mod((y - z) * invmod(x - y, n + 1), n + 1)
    b = mod(y - a * x, n + 1)

    # Now we need to apply `f(i) = a*i + b` `k = niter` times.
    # Observe that
    # f^k(i) = a^k * i + b * (a^{k-1} + a^{k-2} + ... + a + a^0) mod n + 1
    #        = a^k * i + b * (a^k - 1) / (a - 1) mod n + 1
    # This allows us to calculate `f^k(i)` directly without a loop.
    pm = powermod(a, niter, n + 1)
    c = mod(mod(pm - 1, n + 1) * invmod(a - 1, n + 1), n + 1)
    i = mod(pm * i + b * c, n + 1)

    return i
end

function apply_reverse_instructions(instructions, i, decksize)
    # Apply all the instructions from the input in reverse order
    # to an index `i`
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
