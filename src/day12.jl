module Day12

using AdventOfCode2019

function day12(input::String = readInput(joinpath(@__DIR__, "..", "data", "day12.txt")))
    stripChar = (s, r) -> replace(s, Regex("[$r]") => "")
    coordStringList = split(stripChar(input, "<>=xyz,"))
    length(coordStringList) % 3 == 0 || throw(AssertionError("Invalid input"))
    coords = parse.(Int, coordStringList)
    positions = Array{Array{Int,1},1}()
    for i = 1:3:length(coords)
        push!(positions, Array{Int,1}([coords[i], coords[i+1], coords[i+2]]))
    end

    velocities = [zeros(Int, 3) for i=1:length(positions)]

    initial_positions = deepcopy(positions)
    initial_velocities = deepcopy(velocities)

    # Part 1
    nsteps = 1000
    for i = 1:nsteps
        _timestep!(positions, velocities)
    end
    total_energy = _total_energy(positions, velocities)

    # Part 2
    positions = deepcopy(initial_positions)
    velocities = deepcopy(initial_velocities)

    cycles = zeros(Int, 3)
    n = 0
    while iszero(cycles[1]) || iszero(cycles[2]) || iszero(cycles[3])
        _timestep!(positions, velocities)
        n += 1
        for d in findall(x->x==0, cycles)
            if _equals(initial_positions, positions, d) && _equals(initial_velocities, velocities, d)
                cycles[d] = n
            end
        end
    end
    return [total_energy, lcm(cycles)]
end

function _equals(s1, s2, dim)
    length(s1) == length(s2) || return false
    for (x, y) in zip(s1, s2)
        x[dim] == y[dim] || return false
    end
    return true
end

function _update_velocities!(positions, velocities)
    for i = 1:length(positions)
        for j = i+1:length(positions)
            for k = 1:3
                if positions[i][k] > positions[j][k]
                    velocities[i][k] -= 1
                    velocities[j][k] += 1
                elseif positions[i][k] < positions[j][k]
                    velocities[i][k] += 1
                    velocities[j][k] -= 1
                end
            end
        end
    end
end

function _update_positions!(positions, velocities)
    positions .+= velocities
end

function _timestep!(positions, velocities)
    _update_velocities!(positions, velocities)
    _update_positions!(positions, velocities)
end

function _potential_energies(positions)
    return [abs.(pos) |> sum for pos in positions]
end

function _kinetic_energies(velocities)
    return [abs.(vel) |> sum for vel in velocities]
end

function _total_energies(positions, velocities)
    return _potential_energies(positions) .* _kinetic_energies(velocities)
end

function _total_energy(positions, velocities)
    return _total_energies(positions, velocities) |> sum
end


end # module
