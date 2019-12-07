module Day03

using AdventOfCode2019

function day03(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    wires = split.(split(input), ",")
    paths = [Array{Tuple{UnitRange{Int},UnitRange{Int}},1}(undef, length(wire)) for wire in wires]
    corners = [Array{Tuple{Int,Int},1}(undef, length(wire) + 1) for wire in wires]
    corners[1][1], corners[2][1] = (0, 0), (0, 0)
    x, y = 0, 0
    for (iw, wire) in enumerate(wires)
        dirs = [a[1] for a in wire]
        lengths = [parse(Int, a[2:end]) for a in wire]
        for (j, (d, l)) in enumerate(zip(dirs, lengths))
            if d == 'R'
                paths[iw][j] = (x:x+l, y:y)
                corners[iw][j+1] = (x+l, y)
                x += l
            elseif d == 'L'
                paths[iw][j] = (x-l:x, y:y)
                corners[iw][j+1] = (x-l, y)
                x -= l
            elseif d == 'U'
                paths[iw][j] = (x:x, y:y+l)
                corners[iw][j+1] = (x, y+l)
                y += l
            elseif d == 'D'
                paths[iw][j] = (x:x, y-l:y)
                corners[iw][j+1] = (x, y-l)
                y -= l
            else
                throw(AssertionError("Invalid direction"))
            end
        end
        x, y = 0, 0
    end

    # Calculate the intersection points
    common = Array{Tuple{Int,Int},1}(undef,0)
    for seg1 in paths[1]
        for seg2 in paths[2]
            inter = intersect.(seg1, seg2)
            for x in inter[1]
                for y in inter[2]
                    push!(common, (x, y))
                end
            end
        end
    end

    # Evaluate the nearest intersection point
    dists = [abs(x) + abs(y) for (x, y) in common] |> sort
    dists[1] == 0 || throw(AssertionError("Shortest distance is not 0"))

    # Calculate the total distances to each intersection point for both wires
    pathDistances = [zeros(Int, length(common)) for _ in 1:2]
    for (i, path) in enumerate(paths)
        d = 0
        for (k, seg) in enumerate(path)
            for (j, p) in enumerate(common)
                if p[1] in seg[1] && p[2] in seg[2] && pathDistances[i][j] == 0
                    pathDistances[i][j] = d + abs(corners[i][k][1] - p[1]) + abs(corners[i][k][2] - p[2])
                end
            end
            d += sum(length.(seg)) - 2
        end
    end

    totalDistance = pathDistances[1] + pathDistances[2] |> sort
    totalDistance[1] == 0 || throw(AssertionError("Shortest distance is not 0"))

    return [dists[2], totalDistance[2]]
end

end # module
