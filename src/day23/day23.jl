module Day23

using AdventOfCode2019

struct Computer
    task::Union{Task,Nothing}
    input::Union{Channel{Int},Nothing}
    output::Union{Channel{Int},Nothing}
    waiting::Union{Channel{Bool},Nothing}
    address::Int
end

function all_waiting(network::Dict{Int,Computer})
    for (k, v) in network
        k == 255 && continue
        if !isready(v.waiting) || isready(v.input)
            return false
        end
    end
    return true
end

function has_unprocessed_output(network::Dict{Int,Computer})
    for (k, v) in network
        k == 255 && continue
        if isready(v.output)
            return true
        end
    end
    return false
end

function initialize_network(program::Array{Int,1})
    network = Dict{Int,Computer}()
    for i = 0:49
        inp = Channel{Int}(100)
        out = Channel{Int}(100)
        waiting = Channel{Bool}(1)
        address = i
        t = @async AdventOfCode2019.IntCode.run_program!(copy(program), inp, out, nothing; waitingForInput = waiting)
        network[i] = Computer(t, inp, out, waiting, address)

        # Initialize computer by assigning its network address
        put!(network[i].input, i)
        put!(network[i].input, -1)
    end
    network[255] = Computer(nothing, Channel{Int}(100), Channel{Int}(100), Channel{Bool}(1), 255)
    return network
end

function shutdown(network::Dict{Int,Computer})
    for (k, v) in network
        close(v.input)
        close(v.output)
        close(v.waiting)
    end
end

function day23(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    program = parse.(Int, split(input, ','))
    return solve(program)
end

function solve(program::Array{Int,1})
    network = initialize_network(program)
    firstYChannel = Channel{Int}(1)
    lastYChannel = Channel{Int}(1)
    currentNATPacket = [-1, -1]
    @label resume
    while true
        read = false
        for (k, v) in network
            k == 255 && continue
            if isready(v.output)
                read = true
                a = take!(v.output)
                x = take!(v.output)
                y = take!(v.output)
                put!(network[a].input, x)
                put!(network[a].input, y)
            end
        end
        if !read
            for (k, v) in network
                k == 255 && continue
                put!(v.input, -1)
            end
        end
        while true
            if has_unprocessed_output(network)
                break
            elseif all_waiting(network)
                while isready(network[255].input)
                    currentNATPacket[1] = take!(network[255].input)
                    currentNATPacket[2] = take!(network[255].input)
                    if !isready(firstYChannel)
                        put!(firstYChannel, currentNATPacket[2])
                    end
                end
                put!(network[0].input, currentNATPacket[1])
                put!(network[0].input, currentNATPacket[2])
                if isready(lastYChannel)
                    if take!(lastYChannel) == currentNATPacket[2]
                        part1 = take!(firstYChannel)
                        close(firstYChannel)
                        close(lastYChannel)
                        shutdown(network)
                        return [part1, currentNATPacket[2]]
                    end
                end
                put!(lastYChannel, currentNATPacket[2])
                break
            end
            yield()
        end
    end
end

end # module
