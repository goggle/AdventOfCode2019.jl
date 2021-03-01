module Day06

using AdventOfCode2019

struct Node
    name::String
    children::Vector{Node}
    parrent::Union{Nothing,Node}
end

function day06(input::String = readInput(joinpath(@__DIR__, "..", "data", "day06.txt")))
    pairs = split.(split(input), ")")
    tree = Node("COM", [], nothing)
    children = [x[2] for x in pairs if x[1] == "COM"]

    nodes = [tree]
    while length(nodes) != 0
        node = pop!(nodes)
        push!(node.children, [Node(x[2], [], node) for x in pairs if x[1] == node.name]...)
        push!(nodes, node.children...)
    end
    norbits = total_orbits(tree)

    san, sanDist = find(tree, "SAN")
    you, youDist = find(tree, "YOU")

    sanPath, youPath = [], []
    node = san
    while node != nothing
        push!(sanPath, node.name)
        node = node.parrent
    end
    node = you
    while node != nothing
        push!(youPath, node.name)
        node = node.parrent
    end

    nCommonAncestors = 0
    i = length(sanPath)
    j = length(youPath)
    while sanPath[i] == youPath[j]
        i -= 1
        j -= 1
        nCommonAncestors += 1
    end

    return [norbits, sanDist - nCommonAncestors + youDist - nCommonAncestors]
end

function total_orbits(tree::Node)
    count = 0
    node = tree
    children = [(x, 1) for x in node.children]
    while length(children) != 0
        node, depth = pop!(children)
        count += depth
        push!(children, [(x, depth + 1) for x in node.children]...)
    end
    return count
end

function find(tree::Node, name::String)
    if tree.name == name
        return (tree, 0)
    end
    node = tree
    nodes = [(x, 1) for x in node.children]
    while length(nodes) != 0
        node, dist = pop!(nodes)
        if node.name == name
            return (node, dist)
        end
        push!(nodes, [(x, dist + 1) for x in node.children]...)
    end
    return (nothing, -1)
end

end # module
