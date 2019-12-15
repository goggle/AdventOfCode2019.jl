module Day14

using AdventOfCode2019

struct Reaction
    result::Pair{String,Int}
    recipe::Array{Pair{String,Int},1}
end

function day14(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    recipes = _parseInput(input)
    ingredients = _empty_ingredient_dict(recipes, 1)
    nORE = _amount_of_ore!(ingredients, recipes)
    nFuel = _max_fuel(1_000_000_000_000, recipes)
    return [nORE, nFuel]
end

function _parseInput(input::String)
    lines = split(strip(input), "\n")
    recipes = Dict{String,Reaction}()

    for line in lines
        comp = findall(r"\d+\s+[A-Z]+", line)
        last = split(line[comp[end]])
        result = Pair(last[2], parse(Int, last[1]))
        recipeRanges = comp[1:end-1]
        recipe = [Pair(elem[2], parse(Int, elem[1])) for elem in [split(line[r]) for r in recipeRanges]]
        reaction = Reaction(result, recipe)
        recipes[reaction.result.first] = reaction
    end
    return recipes
end

function _empty_ingredient_dict(recipes::Dict{String,Reaction}, init_fuel=0)
    d = Dict{String,Int}()
    d["ORE"] = 0
    for (key, _) in recipes
        d[key] = 0
    end
    d["FUEL"] = init_fuel
    return d
end

function _amount_of_ore!(ingredients::Dict{String,Int}, recipes::Dict{String,Reaction})
    ing = Array{Pair{String,Int},1}()
    for (name, amount) in ingredients
        if name == "ORE"
            continue
        end
        if amount > 0
            push!(ing, Pair(name, amount))
            ingredients[name] = 0
        end
    end
    if length(ing) == 0
        return ingredients["ORE"]
    end
    for (name, amount) in ing
        if name == "ORE"
            continue
        end
        recipe = recipes[name]
        factor = 1
        if recipe.result[2] < amount
            factor = ceil(Int, amount/recipe.result[2])
        end
        ingredients[name] += amount - factor * recipe.result[2]
        for (n, a) in recipe.recipe
            ingredients[n] += factor * a
        end
    end
    return _amount_of_ore!(ingredients, recipes)
end

function _max_fuel(availableORE::Int, recipes::Dict{String,Reaction})
    u = 1
    while true
        nORE = _amount_of_ore!(_empty_ingredient_dict(recipes, u), recipes)
        if nORE > availableORE
            break
        end
        u *= 2
    end
    u == 1 && return 0
    le = u ÷ 2
    while u - le > 1
        m = (le + u) ÷ 2
        nORE = _amount_of_ore!(_empty_ingredient_dict(recipes, m), recipes)
        if nORE > availableORE
            u = m
        else
            le = m
        end
    end
    return le
end

end # module
