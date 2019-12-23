module Day20

using AdventOfCode2019

function day20(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    return solve(input, (true, true))
end

function solve(input, parts)
    solution = Array{Int,1}(undef, sum(parts))
    cm = char_matrix(input)
    imat = int_matrix(cm)
    specialPoints = find_portals(cm)
    portals = create_portal_lookup(specialPoints)
    start = specialPoints["AA"][1]
    finish = specialPoints["ZZ"][1]
    if parts[1]
        solution[1] = flood!(copy(imat), portals, start, finish)
    end
    if parts[2]
        solution[2] = flood_levels(imat, portals, start, finish)
    end
    return solution
end

function char_matrix(input::String)
    m = split.(split(input, "\n"), "")
    nrows = length(m)
    nrows > 1 || throw(ArgumentError("Invalid input"))
    ncols = length(m[1])
    if length(m[end]) <= 1
        nrows -= 1
    end
    for i = 1:nrows
        length(m[i]) == ncols || throw(ArgumentError("Invalid input in row $i"))
    end
    charmat = Array{Char, 2}(undef, nrows, ncols)
    for i = 1:nrows
        for (j, s) in enumerate(m[i])
            charmat[i, j] = m[i][j][1]
        end
    end
    return charmat
end

function int_matrix(charmat::Array{Char,2})
    m, n = size(charmat)
    imat = Array{Int,2}(undef, m, n)
    for i = 1:m
        for j = 1:n
            if charmat[i, j] == '.'  # walkable square
                imat[i, j] = -1
            elseif isuppercase(charmat[i, j])  # letter
                imat[i, j] = -2
            else  # non-walkable square
                imat[i, j] = -3
            end
        end
    end
    return imat
end

function find_portals(charmat::Array{Char,2})
    letterDict = Dict{String,Array{CartesianIndex,1}}()
    letterPos = findall(x -> isuppercase(x), charmat)
    m, n = size(charmat)
    for ci in letterPos
        i, j = ci.I
        if j + 1 <= n && isuppercase(charmat[i, j + 1])
            s = join(charmat[i, j:j+1])
            if !haskey(letterDict, s)
                letterDict[s] = Array{CartesianIndex,1}()
            end
            if j + 2 <= n && charmat[i, j + 2] == '.'
                push!(letterDict[s], CartesianIndex(i, j + 2))
            elseif j - 1 >= 0 && charmat[i, j - 1] == '.'
                push!(letterDict[s], CartesianIndex(i, j - 1))
            end
        end
        if i + 1 <= m && isuppercase(charmat[i + 1, j])
            s = join(charmat[i:i+1, j])
            if !haskey(letterDict, s)
                letterDict[s] = Array{CartesianIndex,1}()
            end
            if i + 2 <= m && charmat[i + 2, j] == '.'
                push!(letterDict[s], CartesianIndex(i + 2, j))
            elseif i - 1 >= 0 && charmat[i - 1, j] == '.'
                push!(letterDict[s], CartesianIndex(i - 1, j))
            end
        end
    end
    return letterDict
end

function create_portal_lookup(letterDict::Dict{String,Array{CartesianIndex,1}})
    lookup = Dict{CartesianIndex,CartesianIndex}()
    for (k, v) in letterDict
        (k == "AA" || k == "ZZ") && continue
        length(v) == 2 || throw(AssertionError("Too many indices for portal $k"))
        lookup[v[1]] = v[2]
        lookup[v[2]] = v[1]
    end
    return lookup
end

function flood!(imat::Array{Int,2}, portals::Dict{CartesianIndex,CartesianIndex}, start::CartesianIndex, finish::CartesianIndex)
    imat[start] = 0
    queue = Array{CartesianIndex,1}()
    push!(queue, start)
    while length(queue) > 0
        current = popfirst!(queue)
        if current == finish
            return imat[current]
        end
        for (k, l) in ((0, 1), (0, -1), (1, 0), (-1, 0))
            if imat[(current.I .+ (k, l))...] == -1
                p = CartesianIndex(current.I .+ (k, l))
                imat[p] = imat[current] + 1
                push!(queue, p)
            end
        end
        if haskey(portals, current)
            p = portals[current]
            if imat[p] == -1
                imat[p] = imat[current] + 1
                push!(queue, p)
            end
        end
    end
end

function is_outer(c::CartesianIndex, m::Int, n::Int)
    (c[1] == 3 || c[1] == m - 2) && return true
    (c[2] == 3 || c[2] == n - 2) && return true
    return false
end

function flood_levels(imat::Array{Int,2}, portals::Dict{CartesianIndex,CartesianIndex}, start::CartesianIndex, finish::CartesianIndex)
    maze = Dict{Int,Array{Int,2}}()
    maze[0] = copy(imat)
    maze[0][start] = 0
    m, n = size(imat)

    queue = Array{Tuple{CartesianIndex,Int},1}()
    level = 0
    push!(queue, (start, level))
    while length(queue) > 0
        current, level = popfirst!(queue)
        if level == 0 && current == finish
            return maze[level][current]
        end
        for (k, l) in ((0, 1), (0, -1), (1, 0), (-1, 0))
            if maze[level][(current.I .+ (k, l))...] == -1
                p = CartesianIndex(current.I .+ (k, l))
                maze[level][p] = maze[level][current] + 1
                push!(queue, (p, level))
            end
        end
        if haskey(portals, current)
            if !is_outer(current, m, n)
                p = portals[current]
                if !haskey(maze, level + 1)
                    maze[level + 1] = copy(imat)
                end
                if maze[level + 1][p] == -1
                    maze[level + 1][p] = maze[level][current] + 1
                    push!(queue, (p, level + 1))
                end
            elseif level > 0  # only inner "portals" allowed for level 0
                p = portals[current]
                if maze[level - 1][p] == -1
                    maze[level - 1][p] = maze[level][current] + 1
                    push!(queue, (p, level - 1))
                end
            end
        end
    end
end

end # module
