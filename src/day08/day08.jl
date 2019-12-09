module Day08

using AdventOfCode2019

function day08(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    digits = parse.(UInt8, split(strip(input), ""))
    height = 6
    width = 25
    nPixels = height * width
    nLayers = length(digits) ÷ nPixels
    layerRanges = [1+(i-1)*nPixels:i*nPixels for i=1:nLayers]

    resultLayerIndex = -1
    minSum = nPixels
    for (i, r) in enumerate(layerRanges)
        s = (digits[r] .== 0) |> sum
        if s < minSum
            minSum = s
            resultLayerIndex = i
        end
    end

    nOneDigits = (digits[layerRanges[resultLayerIndex]] .== 1) |> sum
    nTwoDigits = (digits[layerRanges[resultLayerIndex]] .== 2) |> sum
    resultPart1 = nOneDigits * nTwoDigits

    resultImage = UInt8(2) * ones(UInt8, (width, height))
    for r in layerRanges
        for i = 1:nPixels
            if resultImage[i] in (0, 1) || digits[r][i] == 2
                continue
            end
            resultImage[i] = digits[r][i]
        end
    end

    return [resultPart1, resultImage]
end

function generate_image(image)
    block = '\u2588'
    empty = ' '
    output = ""
    for i = 1:size(image, 2)
        row = join(image[:, i])
        row = replace(row, "1" => block)
        row = replace(row, "0" => empty)
        output *= row * "\n"
    end
    return output
end

end # module
