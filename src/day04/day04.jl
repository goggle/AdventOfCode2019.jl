function day04(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    low, high = parse.(Int, split(input, "-"))
    !((low >= 100_000) && (high <= 999_999)) && throw(AssertionError("Invalid input range"))

    digs = Array{UInt8,1}(undef, 6)
    reverse!(digits!(digs, low))
    first_valid!(digs)

    count1, count2 = 0, 0
    hdigs = Array{UInt8,1}(undef, 6)
    reverse!(digits!(hdigs, high))
    while true
        if has_pair(digs)
            count1 += 1
            if has_exact_pair(digs)
                count2 += 1
            end
        end
        !next!(digs, hdigs) && break
    end
    return [count1, count2]
end

"""
    has_pair(digits::Array{UInt8,1})

Return `true` if the sequence `digits` contains a pair,
otherwise `false`.
"""
function has_pair(digits::Array{UInt8,1})
    for i = 1:length(digits)-1
        digits[i] == digits[i+1] && return true
    end
    return false
end

"""
    has_exact_pair(digits::Array{UInt8,1})

Return `true` if the sequense `digits` contains an exact pair,
otherwise `false`.
"""
function has_exact_pair(digits::Array{UInt8,1})
    digits[1] == digits[2] != digits[3] && return true
    for i = 2:length(digits)-2
        digits[i-1] != digits[i] == digits[i+1] != digits[i+2] && return true
    end
    digits[end] == digits[end-1] != digits[end-2] && return true
    return false
end

"""
    first_valid!(digits::Array{UInt8,1})

Compute the first valid non-decreasing array of digits.
"""
function first_valid!(digits::Array{UInt8,1})
    for i = 1:length(digits)-1
        if digits[i] > digits[i+1]
            for j = i+1:length(digits)
                digits[j] = digits[i]
            end
            break
        end
    end
end

"""
    next!(digits::Array{UInt8,1}, high::Array{UInt8})

Compute the next non-decreasing array of digits. Return `true`
if the value represented by that next array of digits is less
or equal the value represented by the upper bound `high`.
"""
function next!(digits::Array{UInt8,1}, high::Array{UInt8,1})
    i = length(digits)
    while digits[i] == 9
        i -= 1
        if i == 0
            return false
        end
    end
    digits[i] += 1
    for j = i+1:length(digits)
        digits[j] = digits[i]
    end
    for i=1:length(digits)-1
        if digits[i] < high[i]
            return true
        elseif digits[i] > high[i]
            return false
        end
    end
    return digits[end] <= high[end]
end
