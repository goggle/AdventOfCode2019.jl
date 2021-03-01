module Day17

using AdventOfCode2019

function day17(input::String = readInput(joinpath(@__DIR__, "..", "data", "day17.txt")))
    program = parse.(Int, split(input, ','))

    view = read_camera!(copy(program))
    intersections = find_intersections(view)
    part1 = ((x[1]-1) * (x[2]-1) for x in intersections) |> sum

    instructions = full_instruction(view)
    compressed = split_instructions(instructions)
    part2 = control_robot!(compressed, program)
    return [part1, part2]
end

function read_camera!(program::Array{Int,1})
    view = Array{Int,1}()
    out = Channel{Int}(5)
    t = @async AdventOfCode2019.IntCode.run_program!(program, nothing, out, nothing)
    while !istaskdone(t)
        push!(view, take!(out))
    end
    close(out)

    rows = split((strip(join(Char.(view)))),'\n')
    mat = Array{Char,2}(undef, length(rows), length(rows[1]))
    for (i, row) in enumerate(rows)
        for (j, char) in enumerate(row)
            mat[i, j] = char
        end
    end
    return mat
end

function find_intersections(view)
    intersections = Array{CartesianIndex{2},1}()
    for i = 2:size(view, 1) - 1
        for j = 2:size(view, 2) - 1
            if view[i,j] == '#'
                if view[i-1,j] == '#' && view[i+1,j] == '#' && view[i,j-1] == '#' && view[i,j+1] == '#'
                    push!(intersections, CartesianIndex(i, j))
                end
            end
        end
    end
    return intersections
end

function full_instruction(view)
    instructions = Array{Union{Char,Int},1}()
    asciiDirs = ['^', 'v', '<', '>']
    start = findfirst(x -> x in asciiDirs, view)

    direction = 0
    for i = 1:4
        if view[start] == asciiDirs[i]
            direction = i
            break
        end
    end

    neighbours = []
    d = direction
    for i = 1:4
        push!(neighbours, view[(start.I .+ dir_1d_to_2d(d))...])
        d = turn_left(d)
    end
    nLeftTurns = findfirst(x -> x == '#', neighbours) - 1
    if nLeftTurns == 3
        push!(instructions, 'R')
    elseif nLeftTurns == 2
        throw(AssertionError("not solved for this case"))
        push!(instructions, 'L')
        push!(instructions, 'L')
    elseif nLeftTurns == 1
        push!(instructions, 'L')
    end
    for i = 1:nLeftTurns
        direction = turn_left(direction)
    end

    i, j = start.I
    while true
        k, l = (i, j) .+ dir_1d_to_2d(direction)
        if inbounds(k, l, view) && view[k, l] == '#'
            push!(instructions, 1)
            i, j = k, l
            continue
        end
        k, l = (i, j) .+ dir_1d_to_2d(turn_left(direction))
        if inbounds(k, l, view) && view[k, l] == '#'
            push!(instructions, 'L')
            direction = turn_left(direction)
            continue
        end
        k, l = (i, j) .+ dir_1d_to_2d(turn_right(direction))
        if inbounds(k, l, view) && view[k, l] == '#'
            push!(instructions, 'R')
            direction = turn_right(direction)
            continue
        end
        break
    end

    # simplify instructions
    simplifiedInstructions = Array{Union{Char,Int},1}()
    count = 0
    for (i, inst) in enumerate(instructions)
        if inst in ('L', 'R')
            push!(simplifiedInstructions, inst)
        else
            count += inst
            if i + 1 > length(instructions) || isa(instructions[i+1], Char)
                push!(simplifiedInstructions, count)
                count = 0
            end
        end
    end

    instructionPairs = Array{Pair{Char,Int},1}()
    for i = 1:2:length(simplifiedInstructions) - 1
        push!(instructionPairs, Pair(simplifiedInstructions[i], simplifiedInstructions[i+1]))
    end

    return instructionPairs
end

function split_instructions(pairs::Array{Pair{Char,Int},1})
    main, a, b, c = "", "", "", ""
    for lenA = 2:10
        s = join(join.(pairs, ","), ",")
        rega = Regex("^([RL],[0-9]+,?){$lenA}")
        ra = findfirst(rega, s)
        isa(ra, Nothing) && continue
        a = strip(s[ra], ',')
        sa = replace(s, a => "A")
        for lenB = 2:10
            regb = Regex("([RL],[0-9]+,?){$lenB}")
            rb = findall(regb, sa)
            for r in rb
                b = strip(sa[r], ',')
                sb = replace(sa, b => "B")
                for lenC = 2:10
                    regc = Regex("([RL],[0-9]+,?){$lenC}")
                    rc = findall(regc, sb)
                    for t in rc
                        c = strip(sb[t], ',')
                        sc = replace(sb, c => "C")
                        finalreg = r"^([ABC],?){2,10}+$"
                        if !isa(findfirst(finalreg, sc), Nothing)
                            main = sc
                            @goto found
                        end
                    end
                end
            end
        end
    end
    throw(AssertionError("Unable to compress instructions"))
    @label found
    return Dict(
        "Main" => main * "\n",
        "A" => a * "\n",
        "B" => b * "\n",
        "C" => c * "\n",
    )
end

function control_robot!(compressedInstruction, program)
    inp = Channel{Int}(100)
    out = Channel{Int}(1)
    program[1] == 1 || throw(AssertionError("Invalid program"))
    program[1] = 2

    main = [Int(compressedInstruction["Main"][i]) for i in eachindex(compressedInstruction["Main"])]
    a = [Int(compressedInstruction["A"][i]) for i in eachindex(compressedInstruction["A"])]
    b = [Int(compressedInstruction["B"][i]) for i in eachindex(compressedInstruction["B"])]
    c = [Int(compressedInstruction["C"][i]) for i in eachindex(compressedInstruction["C"])]
    vidS = "n\n"
    video = [Int(vidS[i]) for i in eachindex(vidS)]

    t = @async AdventOfCode2019.IntCode.run_program!(program, inp, out, nothing)

    for val in main
        put!(inp, val)
    end
    for val in a
        put!(inp, val)
    end
    for val in b
        put!(inp, val)
    end
    for val in c
        put!(inp, val)
    end
    for val in video
        put!(inp, val)
    end


    while true
        ret = take!(out)
        if istaskdone(t)
            close(inp)
            close(out)
            return ret
        end
    end
end

function inbounds(i::Int, j::Int, view)
    return i >= 1 && j >= 1 && i <= size(view, 1) && j <= size(view, 2)
end

function turn_left(d::Int)
    d == 1 && return 3
    d == 2 && return 4
    d == 3 && return 2
    d == 4 && return 1
end

function turn_right(d::Int)
    d == 1 && return 4
    d == 2 && return 3
    d == 3 && return 1
    d == 4 && return 2
end

function dir_1d_to_2d(d::Int)
    d == 1 && return (-1, 0)
    d == 2 && return (1, 0)
    d == 3 && return (0, -1)
    d == 4 && return (0, 1)
end

function dir_2d_to_1d(d::Tuple{Int,Int})
    d == (-1, 0) && return 1
    d == (1, 0) && return 2
    d == (0, -1) && return 3
    d == (0, 1) && return 4
end

end # module
