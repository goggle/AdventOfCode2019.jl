module Day16

using AdventOfCode2019

function day16(input::String = readInput(joinpath(@__DIR__, "..", "data", "day16.txt")))
    digits = parse.(Int8, split(strip(input), ""))
    p1 = part1!(copy(digits))
    p2 = part2(digits)
    return [p1, p2]
end

function part1!(digits::Array{Int8,1})
    factors = Array{Int8,1}(undef, length(digits))
    newDigits = copy(digits)
    for n = 1:100
        for i = 1:length(digits)
            generate_pattern!(factors, i)
            res = mod(digits .* factors |> sum |> abs, 10)
            newDigits[i] = res
        end
        copy!(digits, newDigits)
    end
    return parse(Int, join(digits[1:8]))
end

function generate_pattern!(pattern::Array{Int8,1}, iter::Int)
    base_pattern = Int8[0, 1, 0, -1]
    bpi = 1
    i = 0
    iteri = 1
    while i <= length(pattern)
        if i != 0
            pattern[i] = base_pattern[bpi]
        end
        iteri += 1
        if iteri > iter
            iteri = 1
            bpi = mod1(bpi + 1, length(base_pattern))
        end
        i += 1
    end
end

function part2(digits::Array{Int8,1})
    tlen = 10_000 * length(digits)
    nskip = parse(Int, join(digits[1:7]))
    rellen = tlen - nskip
    reldigits = Array{Int8,1}(undef, rellen)
    i = rellen
    j = length(digits)
    while i > 0
        reldigits[i] = digits[j]
        i -= 1
        j -= 1
        if j < 1
            j = length(digits)
        end
    end
    for iter = 1:100
        csum = 0
        for i = rellen:-1:1
            csum = mod(csum + reldigits[i], 10)
            reldigits[i] = csum
        end
    end
    return parse(Int, join(reldigits[1:8]))
end

end # module
