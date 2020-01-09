module Day25

using AdventOfCode2019
using Combinatorics

function day25(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    program = parse.(Int, split(input, ","))
    return solve(program)
end

# This last puzzle was an interactive puzzle.
# It has been solved by manually exploring the map and collecting all the
# items which do not lead the game to end.
# After having collected all the items it uses simple brute-force to enter
# the "Pressure-Sensitive Floor" and collecting the password.
#
# This process has been hardcoded in that `solve` method, so it will only
# work for my particular input!
function solve(program::Array{Int,1})
    inp = Channel{Int}(100)
    out = Channel{Int}(1000)
    waiting = Channel{Bool}(1)
    @async AdventOfCode2019.IntCode.run_program!(copy(program), inp, out, nothing; waitingForInput = waiting)

    items = ["mutex", "whirled peas", "cake", "space law space brochure", "loom", "hologram", "manifold", "easter egg"]
    command("north", inp, out)
    command("take mutex", inp, out)
    command("east", inp, out)
    command("east", inp, out)
    command("east", inp, out)
    command("take whirled peas", inp, out)
    command("west", inp, out)
    command("west", inp, out)
    command("west", inp, out)
    command("south", inp, out)
    command("south", inp, out)
    command("take cake", inp, out)
    command("north", inp, out)
    command("west", inp, out)
    command("take space law space brochure", inp, out)
    command("north", inp, out)
    command("take loom", inp, out)
    command("south", inp, out)
    command("south", inp, out)
    command("take hologram", inp, out)
    command("west", inp, out)
    command("take manifold", inp, out)
    command("east", inp, out)
    command("north", inp, out)
    command("east", inp, out)
    command("south", inp, out)
    command("west", inp, out)
    command("south", inp, out)
    command("take easter egg", inp, out)
    command("south", inp, out)

    for combi in Combinatorics.combinations(items)
        drop_all(items, inp, out)
        take_items(combi, inp, out)
        command("south", inp, out; clear_output = false)
        while !isready(out)
            sleep(0.0001)
        end
        os = get_output(out)
        if occursin("heavier", os) || occursin("lighter", os)
            continue
        end
        # println(os)
        m = match(r"\d+", os)
        return parse(Int, m.match)
        break
    end

    # while true
    #     print("> "); n = readline()
    #     if n == "read"
    #         o = Int[]
    #         while isready(out)
    #             push!(o, take!(out))
    #         end
    #         print(join(Char.(o)))
    #         continue
    #     end
    #     if n == "exit" || n == "quit" || n == "q"
    #         return
    #     end
    #     input = push!([Int(x) for x in n], 10)
    #     for x in input
    #         put!(inp, x)
    #     end
    # end
end

function get_output(out::Channel{Int})
    o = Int[]
    while isready(out)
        push!(o, take!(out))
    end
    return join(Char.(o))
end

function command(c::String, inp::Channel{Int}, out::Channel{Int}; clear_output = true)
    commandInts = push!([Int(x) for x in c], 10)
    for x in commandInts
        put!(inp, x)
    end
    if clear_output
        while !isready(out)
            sleep(0.0001)
        end
        while isready(out)
            take!(out)
        end
    end
end

function drop_all(items::Array{String,1}, inp::Channel{Int}, out::Channel{Int})
    for item in items
        c = "drop " * item
        command(c, inp, out)
    end
end

function take_items(items::Array{String,1}, inp::Channel{Int}, out::Channel{Int})
    for item in items
        c = "take " * item
        command(c, inp, out)
    end
end

end # module
