module Day18

using AdventOfCode2019

struct Key
    pos::CartesianIndex
    dist::Int
    doors::Array{Char,1}
    keys::Array{Char,1}
end

function day18(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    maze = parse_input(input)
    p1 = part1(maze)

    modify_maze!(maze)
    p2 = part2(maze)

    return [p1, p2]
end

function part1(maze::Array{Char,2})
    specialKeys = ['@']
    dists = generate_dists(maze, specialKeys)
    memo = Dict{Tuple{BitSet,BitSet,BitSet},Int}()
    keys = [x for x in maze if islowercase(x)]
    return shortest_distance!(dists, specialKeys, keys, Array{Char,1}(), memo)
end

function part2(maze::Array{Char,2})
    specialKeys = ['1', '2', '3', '4']
    dists = generate_dists(maze, specialKeys)
    memo = Dict{Tuple{BitSet,BitSet,BitSet},Int}()
    keys = [x for x in maze if islowercase(x)]
    return shortest_distance!(dists, specialKeys, keys, Array{Char,1}(), memo)
end

function parse_input(input::String)
    m = hcat(split.(split(strip(input), '\n'), "")...)
    maze = Array{Char,2}(undef, size(m, 2), size(m, 1))
    for i = 1:size(m, 2)
        for j = 1:size(m, 1)
            maze[i, j] = Char(m[j, i][1])
        end
    end
    return maze
end

function generate_dists(maze, specialKeys)
    dists = Dict{Char,Dict{Char,Key}}()
    keys = [x for x in maze if islowercase(x)]
    for k in union(keys, specialKeys)
        dists[k] = flood(maze, k)
    end
    return dists
end

function flood(maze::Array{Char,2}, start::Char)
    cmaze = copy(maze)
    startInd = findfirst(x -> x == start, maze)
    distDict = Dict{Char,Key}()
    queue = Array{Key,1}()
    push!(queue, Key(startInd, 0, [], []))
    while length(queue) > 0
        currentKey = popfirst!(queue)
        if islowercase(cmaze[currentKey.pos]) || cmaze[currentKey.pos] in ('@', '1', '2', '3', '4')
            distDict[cmaze[currentKey.pos]] = deepcopy(currentKey)
            if islowercase(cmaze[currentKey.pos])
                push!(currentKey.keys, cmaze[currentKey.pos])
            end
        elseif isuppercase(cmaze[currentKey.pos])
            push!(currentKey.doors, cmaze[currentKey.pos])
        end
        cmaze[currentKey.pos] = '#'
        for (k, l) in ((-1, 0), (1, 0), (0, -1), (0, 1))
            if cmaze[(currentKey.pos.I .+ (k, l))...] != '#'
                push!(
                    queue, Key(CartesianIndex(currentKey.pos.I .+ (k, l)),
                    currentKey.dist + 1, copy(currentKey.doors), copy(currentKey.keys)))
            end
        end
    end
    return distDict
end

function modify_maze!(maze::Array{Char,2})
    atPos = findfirst(x -> x == '@', maze)
    maze[atPos[1]-1:atPos[1]+1, atPos[2]-1:atPos[2]+1] .= ['1' '#' '2';
                                                           '#' '#' '#';
                                                           '3' '#' '4']
end

function shortest_distance!(dists::Dict{Char,Dict{Char,Key}}, current::Array{Char}, remainingKeys::Array{Char,1}, unlockedDoors::Array{Char,1}, memo::Dict{Tuple{BitSet,BitSet,BitSet},Int})
    length(remainingKeys) == 0 && return 0
    candids = [Array{Char,1}() for i = 1:length(current)]
    for i = 1:length(current)
        for key in remainingKeys
            haskey(dists[current[i]], key) || continue
            iscandid = true
            # Robot must be able to reach `key`. Otherwise it cannot
            # be considered as a candidate.
            for door in dists[current[i]][key].doors
                if !(door in unlockedDoors)
                    iscandid = false
                    break
                end
            end
            !iscandid && continue
            # If the robot would collect other keys on its way from
            # `current` to `key`, we do not consider `key` to be a
            # candidate.
            for k in dists[current[i]][key].keys
                if k in remainingKeys
                    iscandid = false
                    break
                end
            end
            if iscandid
                push!(candids[i], key)
            end
        end
    end
    state = (BitSet(Int.(current)), BitSet(Int.(remainingKeys)), BitSet(Int.(unlockedDoors)))
    haskey(memo, state) && return memo[state]
    total = minimum(
        [dists[current[i]][c].dist + shortest_distance!(
            dists, replace(x -> x == current[i] ? c : x, current), setdiff(remainingKeys, c), union(unlockedDoors, uppercase.(dists[current[i]][c].keys), [uppercase(c)]), memo) for i=1:length(current) for c in candids[i]])
    memo[state] = total
    return total
end

end # module
