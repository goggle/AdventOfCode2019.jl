module Day10

using AdventOfCode2019
using LinearAlgebra

function day10(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    asteroidMap = _generate_map(input)
    station, maxAsteroids = _evaluate_best_asteroid(asteroidMap)
    vapo = _vaporize(asteroidMap, station, 200)
    vapo_puzzle_coords = _to_puzzle_coordinates(vapo)
    solution_part2 = 100vapo_puzzle_coords[1] + vapo_puzzle_coords[2]
    return [maxAsteroids, solution_part2]
end

function _to_puzzle_coordinates(c::CartesianIndex)
    return CartesianIndex(c[2]-1, c[1]-1)
end

function _evaluate_best_asteroid(asteroidMap::Array{Bool,2})
    maxCoord = CartesianIndex(-1, -1)
    maxCount = 0
    asteroidCoords = findall(asteroidMap)
    for a in asteroidCoords
        count = 0
        cp = copy(asteroidCoords)
        filter!(x -> x != a, cp)
        while length(cp) != 0
            b = pop!(cp)
            list = Array{CartesianIndex,1}()
            for ast in cp
                if _on_line(ast, a, b)
                    push!(list, ast)
                end
            end
            filter!(x -> !(x in list), cp)
            if _in_between(a, b, list)
                count += 2
            else
                count += 1
            end
        end
        if count > maxCount
            maxCount = count
            maxCoord = a
        end
    end
    return maxCoord, maxCount
end

function _generate_map(input::String)
    sinp = split(input)
    nrows = length(sinp)
    ncols = length(sinp[1])
    asteroidMap = zeros(Bool, (nrows, ncols))
    for (i, row) in enumerate(sinp)
        for (j, col) in enumerate(row)
            if col == '#'
                asteroidMap[i, j] = 1
            end
        end
    end
    return asteroidMap
end

function _on_line(p::CartesianIndex, a::CartesianIndex, b::CartesianIndex)
    return dot(b.I .- a.I, p.I .- a.I)^2 == sum((b.I .- a.I).^2) * sum((p.I .- a.I).^2)
end

function _in_between(p::CartesianIndex, b::CartesianIndex, list::Array{CartesianIndex,1})
    m = min(p, b, list...)
    M = max(p, b, list...)
    if p[1] == m[1]
        (p[2] == m[2] || p[2] == M[2]) && return false
    elseif p[1] == M[1]
        (p[2] == m[2] || p[2] == M[2]) && return false
    end
    return true
end

function _vaporize(asteroidMap::Array{Bool,2}, station::CartesianIndex, n::Int)
    asteroidCoords = findall(asteroidMap)
    filter!(x->x!=station, asteroidCoords)

    asteroidCoordsRight = copy(asteroidCoords)
    filter!(x -> (x[2] > station[2] || (x[2] == station[2] && x[1] < station[1])), asteroidCoordsRight)
    asteroidCoordsLeft = copy(asteroidCoords)
    filter!(x->!(x in asteroidCoordsRight), asteroidCoordsLeft)

    dirsRight = Array{CartesianIndex,1}()
    while length(asteroidCoordsRight) != 0
        ast = pop!(asteroidCoordsRight)
        filter!(x->!_on_line(x, station, ast), asteroidCoordsRight)
        push!(dirsRight, ast)
    end

    up = CartesianIndex(-1, 0)
    sort!(dirsRight, by=x->dot(up.I, (x-station).I)/(norm(up.I)*norm((x-station).I)), rev=true)

    dirsLeft = Array{CartesianIndex,1}()
    while length(asteroidCoordsLeft) != 0
        ast = pop!(asteroidCoordsLeft)
        filter!(x->!_on_line(x, station, ast), asteroidCoordsLeft)
        push!(dirsLeft, ast)
    end

    down = CartesianIndex(1, 0)
    sort!(dirsLeft, by=x->dot(down.I, (x-station).I)/(norm(down.I)*norm((x-station).I)), rev=true)

    dirs = union(dirsRight, dirsLeft)

    i = 1
    c = 0
    filter!(x->x!=station, asteroidCoords)
    length(asteroidCoords) < n && throw(AssertionError("not enough asteroids"))
    while true
        dir = dirs[i]
        candidates = []
        for ast in asteroidCoords
            if _on_line(ast, station, dir) && dot((ast-station).I, (dir-station).I) > 0
                push!(candidates, ast)
            end
        end
        if length(candidates) > 0
            ind = argmin([norm((x-station).I) for x in candidates])
            vapo = candidates[ind]
            filter!(x->x!=vapo, asteroidCoords)
            c += 1
            if c == n
                return vapo
            end
        end
        i = mod1(i + 1, length(dirs))
    end
end

end # module
