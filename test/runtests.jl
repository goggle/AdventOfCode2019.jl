using AdventOfCode2019
using Test

@testset "Day 1" begin
    @test AdventOfCode2019.day01() == [3442987, 5161601]
end

@testset "Day 2" begin
    @test AdventOfCode2019.day02() == [3101844, 8478]
end

@testset "Day 3" begin
    inp1 = "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83"
    @test AdventOfCode2019.day03(inp1) == [159, 610]
    inp2 = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
    @test AdventOfCode2019.day03(inp2) == [135, 410]
    @test AdventOfCode2019.day03() == [1983, 107754]
end

@testset "Day 4" begin
    @test AdventOfCode2019.day04() == [1675, 1142]
end
