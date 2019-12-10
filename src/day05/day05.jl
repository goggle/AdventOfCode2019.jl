module Day05

using AdventOfCode2019

function day05(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    data = parse.(Int, split(input, ","))

    c1 = Channel{Int}(2)
    put!(c1, 1)
    out1 = _run_program(copy(data), c1, nothing, nothing)
    close(c1)

    c2 = Channel{Int}(2)
    put!(c2, 5)
    out2 = _run_program(copy(data), c2, nothing, nothing)
    close(c2)

    return [out1[end], out2[end]]
end

function _run_program(data::Array{T, 1}, input::Channel{T}, output::Union{Channel{T},Nothing}, done::Union{Channel{Bool}, Nothing}) where T <: Integer
    out = Array{T,1}()

    i = 1  # instruction pointer
    relativeBase = 1  # relative base
    digs = Array{UInt8,1}(undef, 5)
    modes = Array{UInt8,1}(undef, 3)
    while true
        fill!(digs, zero(UInt8))
        digits!(digs, data[i])
        optcode = digs[1] + 10digs[2]

        # modes for parameters 1, 2 and 3
        # mode 0: position mode
        # mode 1: immediate mode
        # mode 2: relative mode
        modes .= digs[3:end]

        if optcode == 99
            break
        elseif optcode == 1 || optcode == 2  # addition and multiplication
            params = [_parameter(data, i + j, relativeBase, modes[j]) for j = 1:3]
            op = optcode == 1 ? eval(+) : eval(*)
            data[params[3]] = op(data[params[1]], data[params[2]])
            i += 4
        elseif optcode == 3  # read input
            param = _parameter(data, i + 1, relativeBase, modes[1])
            data[param] = take!(input)
            i += 2
        elseif optcode == 4  # output
            param = _parameter(data, i + 1, relativeBase, modes[1])
            value = data[param]
            if output == nothing
                push!(out, value)
            else
                put!(output, value)
            end
            i += 2
        elseif optcode == 5 || optcode == 6 # jump-if-true and jump-if-false
            par1 = _parameter(data, i + 1, relativeBase, modes[1])
            op = optcode == 5 ? eval(!=) : eval(==)
            if op(data[par1], 0)
                par2 = _parameter(data, i + 2, relativeBase, modes[2])
                i = data[par2] + 1
            else
                i += 3
            end
        elseif optcode == 7 || optcode == 8  # less than and equals
            params = [_parameter(data, i + j, relativeBase, modes[j]) for j = 1:3]
            op = optcode == 7 ? eval(<) : eval(==)
            data[params[3]] = op(data[params[1]], data[params[2]]) ? 1 : 0
            i += 4
        elseif optcode == 9  # adjust relative base
            param = _parameter(data, i + 1, relativeBase, modes[1])
            relativeBase += param
        else
            throw(AssertionError("Invalid optcode: $optcode"))
        end
    end
    if done != nothing
        put!(done, true)
    end
    return out
end

function _get(data::Array{T,1}, index::Int) where T <: Integer
    if index > length(data)
        resize!(data, index)
    end
    return data[index]
end

function _set!(data::Array{T,1}, index::Int, value::T) where T <: Integer
    if index > length(data)
        resize!(data, index)
    end
    data[index] = value
end

function _parameter(data::Array{T,1}, index::Int, relativeBase::Int, mode::UInt8) where T <: Integer
    if mode == 0
        return data[index] + 1
    elseif mode == 1
        return index
    elseif mode == 2
        return data[relativeBase] + 1
    end
end

function _run_program(data::Array{Int, 1}, input::Array{Int,1}=[])
    c = Channel{Int}(length(input)+1)
    for value in input
        put!(c, value)
    end
    out = _run_program(data, c, nothing, nothing)
    close(c)
    return out
end

end # module
