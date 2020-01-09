module IntCode

using AdventOfCode2019

function run_program!(data::Array{T, 1}, input::Union{Channel{T},Nothing}, output::Union{Channel{T},Nothing}, done::Union{Channel{Bool},Nothing}; waitingForInput::Union{Channel{Bool},Nothing} = nothing) where T <: Integer
    out = Array{T,1}()

    i = T(1)  # instruction pointer
    relativeBase = T(0)  # relative base
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
            val = op(_get(data, params[1]), _get(data, params[2]))
            _set!(data, params[3], val)
            i += 4
        elseif optcode == 3  # read input
            param = _parameter(data, i + 1, relativeBase, modes[1])
            if input != nothing
                if waitingForInput != nothing
                    put!(waitingForInput, true)
                end
                _set!(data, param, take!(input))
                if waitingForInput != nothing
                    take!(waitingForInput)
                end
            end
            i += 2
        elseif optcode == 4  # output
            param = _parameter(data, i + 1, relativeBase, modes[1])
            value = _get(data, param)
            if output == nothing
                push!(out, value)
            else
                put!(output, value)
            end
            i += 2
        elseif optcode == 5 || optcode == 6 # jump-if-true and jump-if-false
            par1 = _parameter(data, i + 1, relativeBase, modes[1])
            op = optcode == 5 ? eval(!=) : eval(==)
            if op(_get(data, par1), 0)
                par2 = _parameter(data, i + 2, relativeBase, modes[2])
                i = _get(data, par2) + 1
            else
                i += 3
            end
        elseif optcode == 7 || optcode == 8  # less than and equals
            params = [_parameter(data, i + j, relativeBase, modes[j]) for j = 1:3]
            op = optcode == 7 ? eval(<) : eval(==)
            value = op(_get(data, params[1]), _get(data, params[2]))
            _set!(data, params[3], value ? T(1) : T(0))
            i += 4
        elseif optcode == 9  # adjust relative base
            param = _parameter(data, i + 1, relativeBase, modes[1])
            relativeBase += _get(data, param)
            i += 2
        else
            throw(AssertionError("Invalid optcode: $optcode"))
        end
    end
    if done != nothing
        put!(done, true)
    end
    return out
end

@inline function _get(data::Array{T,1}, index::T) where T <: Integer
    if index > length(data)
        return T(0)
    end
    return data[index]
end

@inline function _set!(data::Array{T,1}, index::T, value::T) where T <: Integer
    n = length(data)
    if index > n
        resize!(data, index)
        data[n+1:index] .= T(0)
    end
    data[index] = value
end

@inline function _parameter(data::Array{T,1}, index::T, relativeBase::T, mode::UInt8) where T <: Integer
    if mode == 0
        return data[index] + 1
    elseif mode == 1
        return index
    elseif mode == 2
        return data[index] + relativeBase + 1
    end
    throw(AssertionError("Invalid mode $mode"))
end

function run_program!(data::Array{T,1}, input::Array{T,1}) where T <: Integer
    c = Channel{Int}(length(input)+1)
    for value in input
        put!(c, value)
    end
    out = run_program!(data, c, nothing, nothing)
    close(c)
    return out
end

end # module
