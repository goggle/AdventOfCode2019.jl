function day03(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    wire1, wire2 = split.(split(input), ",")
    paths = [[], []]
    corners = [[(0, 0)], [(0, 0)]]
    i = 1
    x, y = 0, 0
    for wire in (wire1, wire2)
        dirs = [a[1] for a in wire]
        lengths = [parse(Int, a[2:end]) for a in wire]
        for (d, l) in zip(dirs, lengths)
            if d == 'R'
                push!(paths[i], (x:x+l, y))
                push!(corners[i], (x+l, y))
                x += l
            elseif d == 'L'
                push!(paths[i], (x-l:x, y))
                push!(corners[i], (x-l, y))
                x -= l
            elseif d == 'U'
                push!(paths[i], (x, y:y+l))
                push!(corners[i], (x, y+l))
                y += l
            elseif d == 'D'
                push!(paths[i], (x, y-l:y))
                push!(corners[i], (x, y-l))
                y -= l
            else
                throw(AssertionError("Invalid direction"))
            end
        end
        i += 1
        x, y = 0, 0
    end

    # Calculate the intersection points
    common = []
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
