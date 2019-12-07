module Day05

using AdventOfCode2019

function day05(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    data = parse.(Int, split(input, ","))
    out1 = _run_program(copy(data), 1)
    out2 = _run_program(copy(data), 5)
    return [out1[end], out2[end]]
end

function _run_program(data::Array{Int, 1}, input::Int)
    out = Array{Int,1}()

    i = 1  # instruction pointer
    digs = Array{UInt8,1}(undef, 5)
    modes = Array{UInt8,1}(undef, 3)
    while true
        fill!(digs, zero(UInt8))
        digits!(digs, data[i])
        optcode = digs[1] + 10digs[2]

        # modes for parameters 1, 2 and 3
        # mode 0: position mode
        # mode 1: immediate mode
        modes .= digs[3:end]

        if optcode == 99
            break
        elseif optcode == 1 || optcode == 2
            par1 = (modes[1] == 0) ? data[data[i+1]+1] : data[i+1]
            par2 = (modes[2] == 0) ? data[data[i+2]+1] : data[i+2]
            if modes[3] == 0
                par3 = data[i+3] + 1
                if optcode == 1  # addition
                    data[par3] = par1 + par2
                elseif optcode == 2  # multiplication
                    data[par3] = par1 * par2
                end
            end
            i += 4
        elseif optcode == 3  # read input
            address = data[i+1]
            data[address+1] = input
            i += 2
        elseif optcode == 4  # output
            val = (modes[1] == 0) ? data[data[i+1]+1] : data[i+1]
            push!(out, val)
            i += 2
        elseif optcode == 5  # jump-if-true
            par1 = (modes[1] == 0) ? data[data[i+1]+1] : data[i+1]
            if par1 != 0
                par2 = (modes[2] == 0) ? data[data[i+2]+1] : data[i+2]
                i = par2 + 1
            else
                i += 3
            end
        elseif optcode == 6  # jump-if-false
            par1 = (modes[1] == 0) ? data[data[i+1]+1] : data[i+1]
            if par1 == 0
                par2 = (modes[2] == 0) ? data[data[i+2]+1] : data[i+2]
                i = par2 + 1
            else
                i += 3
            end
        elseif optcode == 7  # less than
            par1 = (modes[1] == 0) ? data[data[i+1]+1] : data[i+1]
            par2 = (modes[2] == 0) ? data[data[i+2]+1] : data[i+2]
            if par1 < par2
                if modes[3] == 0
                    data[data[i+3]+1] = 1
                else
                    data[i+3] = 1
                end
            else
                if modes[3] == 0
                    data[data[i+3]+1] = 0
                else
                    data[i+3] = 0
                end
            end
            i += 4
        elseif optcode == 8  # equals
            par1 = (modes[1] == 0) ? data[data[i+1]+1] : data[i+1]
            par2 = (modes[2] == 0) ? data[data[i+2]+1] : data[i+2]
            if par1 == par2
                if modes[3] == 0
                    data[data[i+3]+1] = 1
                else
                    data[i+3] = 1
                end
            else
                if modes[3] == 0
                    data[data[i+3]+1] = 0
                else
                    data[i+3] = 0
                end
            end
            i += 4
        else
            throw(AssertionError("Invalid optcode: $optcode"))
        end
    end
    return out
end

end # module
