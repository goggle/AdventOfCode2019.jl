module Day24

using AdventOfCode2019

function day24(input::String = readInput(joinpath(@__DIR__, "..", "data", "day24.txt")))
    layout = parse_input(input)
    p1 = part1(layout)
    p2 = part2(layout)
    return [p1, p2]
end

function part1(layout::Array{Bool,2})
    state = copy(layout)
    tmp = similar(state)
    ratings = [biodiversity_rating(state)]
    while true
        next_state!(tmp, state)
        copy!(state, tmp)
        br = biodiversity_rating(state)
        if br in ratings
            return br
        end
        push!(ratings, br)
    end
end

function part2(layout::Array{Bool,2}; niter::Int = 200)
    layers = initialize_layers(layout)
    for i = 1:niter
        next_state!(layers)
    end
    return sum.(values(layers)) |> sum
end

function parse_input(input::String)
    layout = zeros(Bool, 5, 5)
    sp = split(input, "\n")
    for (i, row) in enumerate(sp)
        for (j, c) in enumerate(row)
            if sp[i][j] == '#'
                layout[i, j] = true
            end
        end
    end
    return layout
end

function in_bounds(i::Int, j::Int, layout::Array{Bool,2})
    return i > 0 && j > 0 && i <= size(layout, 1) && j <= size(layout, 2)
end

function number_of_infested_neighbours(i::Int, j::Int, layout::Array{Bool,2}; exclude_middle = false)
    n = 0
    for (k, l) in ((-1, 0), (1, 0), (0, -1), (0, 1))
        if in_bounds(i + k, j + l, layout) && layout[i + k, j + l]
            if exclude_middle && ceil.(Int, size(layout) ./ 2) == (i + k, j + l)
                continue
            end
            n += 1
        end
    end
    return n
end

function number_of_infested_neighbours(i::Int, j::Int, l::Int, layers::Dict{Int,Array{Bool,2}})
    if i == 3 && j == 3
        return 0
    end
    n = number_of_infested_neighbours(i, j, layers[l]; exclude_middle = true)
    if i == 1 && haskey(layers, l - 1) && layers[l - 1][2, 3]
        n += 1
    end
    if j == 1 && haskey(layers, l - 1) && layers[l - 1][3, 2]
        n += 1
    end
    if i == 5 && haskey(layers, l - 1) && layers[l - 1][4, 3]
        n += 1
    end
    if j == 5 && haskey(layers, l - 1) && layers[l - 1][3, 4]
        n += 1
    end
    if i == 2 && j == 3 && haskey(layers, l + 1)
        for j = 1:5
            if layers[l + 1][1, j]
                n += 1
            end
        end
    end
    if i == 4 && j == 3 && haskey(layers, l + 1)
        for j = 1:5
            if layers[l + 1][5, j]
                n += 1
            end
        end
    end
    if i == 3 && j == 2 && haskey(layers, l + 1)
        for i = 1:5
            if layers[l + 1][i, 1]
                n += 1
            end
        end
    end
    if i == 3 && j == 4 && haskey(layers, l + 1)
        for i = 1:5
            if layers[l + 1][i, 5]
                n += 1
            end
        end
    end
    return n
end

function next_state!(dest::Array{Bool,2}, source::Array{Bool,2})
    copy!(dest, source)
    for i = 1:size(source, 1)
        for j = 1:size(source, 2)
            n = number_of_infested_neighbours(i, j, source)
            if source[i, j]
                if n != 1
                    dest[i, j] = false
                end
            else
                if n == 1 || n == 2
                    dest[i, j] = true
                end
            end
        end
    end
end

function next_state!(layers::Dict{Int,Array{Bool,2}})
    add_two_layers!(layers)
    source = deepcopy(layers)
    for l in keys(source)
        for i = 1:5
            for j = 1:5
                n = number_of_infested_neighbours(i, j, l, source)
                if source[l][i, j]
                    if n != 1
                        layers[l][i, j] = false
                    end
                else
                    if n == 1 || n == 2
                        layers[l][i, j] = true
                    end
                end
            end
        end
    end
end

function biodiversity_rating(layout::Array{Bool,2})
    rating = 0
    for i in eachindex(layout)
        if layout'[i]
            rating += 2^(i - 1)
        end
    end
    return rating
end

function initialize_layers(layout::Array{Bool,2})
    layers = Dict{Int,Array{Bool,2}}()
    layers[0] = copy(layout)
    return layers
end

function add_two_layers!(layers::Dict{Int,Array{Bool,2}})
    mi = minimum(keys(layers))
    ma = maximum(keys(layers))
    layers[mi - 1] = zeros(Bool, size(layers[mi]))
    layers[ma + 1] = zeros(Bool, size(layers[ma]))
end

end # module
