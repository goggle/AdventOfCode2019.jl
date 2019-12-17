module Day15

using AdventOfCode2019
using OffsetArrays

const opposite_direction = Dict(
    0 => 0,
    1 => 2,
    2 => 1,
    3 => 4,
    4 => 3
)

function day15(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    program = parse.(Int, split(input, ","))
    grid, pos = explore_map(program)
    flood!(grid, pos[1], pos[2], 0)
    return [grid[0, 0], maximum(grid)]
end

function explore_map(program::Array{Int,1})
    inp = Channel{Int}(1)
    out = Channel{Int}(1)
    oxyPos = Channel{CartesianIndex}(1)

    @async AdventOfCode2019.IntCode.run_program!(program, inp, out, nothing)

    gridD = Dict{CartesianIndex{2}, Int}()
    walk!(0, 0, 0, gridD, inp, out, oxyPos)
    pos = take!(oxyPos)

    x1 = minimum(x->x[1] - 1, keys(gridD))
    x2 = maximum(x->x[1] + 1, keys(gridD))
    y1 = minimum(x->x[2] - 1, keys(gridD))
    y2 = maximum(x->x[2] + 1, keys(gridD))
    grid = -1 * ones(Int, x1:x2, y1:y2)
    for (key, entry) in gridD
        grid[key] = entry
    end

    close(inp)
    close(out)
    close(oxyPos)
    return grid, pos
end

function walk!(i::Int, j::Int, backdir::Int, gridD::Dict{CartesianIndex{2}, Int}, inp::Channel{Int}, out::Channel{Int}, oxyPos::Channel{CartesianIndex})
    gridD[CartesianIndex(i, j)] = 0
    for d in 1:4
        di, dj = dir_1d_to_2d(d)
        if !haskey(gridD, CartesianIndex(i + di, j + dj))
            put!(inp, d)
            status = take!(out)
            if status == 0
                gridD[CartesianIndex(i + di, j + dj)] = -2
                continue
            elseif status == 2
                put!(oxyPos, CartesianIndex(i + di, j + dj))
            end
            walk!(i + di, j + dj, opposite_direction[d], gridD, inp, out, oxyPos)
        end
    end
    backdir == 0 && return
    put!(inp, backdir)
    take!(out)
end

function flood!(grid::OffsetArrays.OffsetArray{Int64,2,Array{Int64,2}}, i::Int, j::Int, backdir::Int)
    for d in 1:4
        d == backdir && continue
        di, dj = dir_1d_to_2d(d)
        if grid[i + di, j + dj] > grid[i, j] || grid[i + di, j + dj] == 0
            grid[i + di, j + dj] = grid[i, j] + 1
            flood!(grid, i + di, j + dj, opposite_direction[d])
        end
    end
end

function dir_1d_to_2d(dir::Int)
    dir == 1 && return (-1, 0)
    dir == 2 && return (1, 0)
    dir == 3 && return (0, -1)
    dir == 4 && return (0, 1)
    throw(AssertionError("invalid direction"))
end

end # module
