function day04(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    inputRange = parse.(Int, split(input, "-"))
    low, high = six_digits(inputRange)

    count1, count2 = 0, 0
    digs = Array{UInt8, 1}(undef, 6)
    for n = low:high
        reverse!(digits!(digs, n))
        if has_pair(digs) && is_non_decreasing(digs)
            if has_exact_pair(digs)
                count2 += 1
            end
            count1 += 1
        end
    end
    return [count1, count2]
end

#function day04(input::String = readInput(joinpath(@__DIR__, "input.txt")))
#    inputRange = parse.(Int, split(input, "-"))
#    low, high = six_digits(inputRange)
#end

function six_digits(inp::Array{Int,1})
    low = inp[1]
    if inp[1] < 100_000
        low = 100_000
    end
    high = inp[2]
    if inp[2] > 999_999
        high = 999_999
    end
    return low, high
end

function has_pair(digits::Array{UInt8,1})
    for i = 1:length(digits)-1
        digits[i] == digits[i+1] && return true
    end
    return false
end

function has_exact_pair(digits::Array{UInt8,1})
    digits[1] == digits[2] != digits[3] && return true 
    for i = 2:length(digits)-2
        digits[i-1] != digits[i] == digits[i+1] != digits[i+2] && return true
    end
    digits[end] == digits[end-1] != digits[end-2] && return true
    return false
end

function is_non_decreasing(digits::Array{UInt8,1})
    for i = 1:length(digits)-1
        digits[i] > digits[i+1] && return false 
    end
    return true
end
