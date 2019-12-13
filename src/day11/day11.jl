module Day11

using AdventOfCode2019

struct Panel
    position::CartesianIndex
    color::UInt8
end

const directions = Dict(
    0 => (1, 0),   # right
    1 => (0, -1),  # down
    2 => (-1, 0),  # left
    3 => (0, 1)    # up
)

function day11(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    program = parse.(Int, split(input, ","))

    path = run_painting_robot(program, 0)
    nPaintedPanels = length(unique([p.position for p in path]))

    path = run_painting_robot(program, 1)
    minX = minimum(x->x.position[1], path)
    maxX = maximum(x->x.position[1], path)
    minY = minimum(x->x.position[2], path)
    maxY = maximum(x->x.position[2], path)
    panelMap = zeros(Int, (maxX-minX+1, maxY-minY+1))
    for panel in path
        panelMap[panel.position[1]-minX+1, (maxY-minY+1)-(panel.position[2]-minY)] = (panel.color == 1) ? 1 : 0
    end

    return [nPaintedPanels, panelMap]
end

function run_painting_robot(program::Array{Int,1}, initialColor::Int)
    path = Array{Panel,1}()
    position = CartesianIndex(0, 0)
    direction = 3

    status = Channel{Bool}(1)
    input = Channel{Int}(1)
    put!(input, initialColor)
    output = Channel{Int}(2)

    t = @task AdventOfCode2019.Day05._run_program(program, input, output, nothing)
    schedule(t)

    while !istaskdone(t)
        color = take!(output)
        turn = take!(output)
        push!(path, Panel(position, color))
        if turn == 0
            direction = turn_left(direction)
        elseif turn == 1
            direction = turn_right(direction)
        end
        position = move(position, direction)
        colorIn = 0
        for i = length(path):-1:1
            if path[i].position == position
                colorIn = path[i].color
                break
            end
        end
        put!(input, colorIn)
    end
    close(output)
    close(input)
    return path
end

function turn_right(dir::Int)
    return mod(dir + 1, 4)
end

function turn_left(dir::Int)
    return mod(dir - 1, 4)
end

function move(pos::CartesianIndex, dir::Int)
    return CartesianIndex(pos.I .+ directions[dir])
end

end # module
