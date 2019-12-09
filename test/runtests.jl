using AdventOfCode2019
using Test

@testset "Day 1" begin
    @test AdventOfCode2019.Day01.day01() == [3442987, 5161601]
end

@testset "Day 2" begin
    @test AdventOfCode2019.Day02.day02() == [3101844, 8478]
end

@testset "Day 3" begin
    inp1 = "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83"
    @test AdventOfCode2019.Day03.day03(inp1) == [159, 610]
    inp2 = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
    @test AdventOfCode2019.Day03.day03(inp2) == [135, 410]
    @test AdventOfCode2019.Day03.day03() == [1983, 107754]
end

@testset "Day 4" begin
    @test AdventOfCode2019.Day04.day04() == [1675, 1142]
end

@testset "Day 5" begin
    inp = parse.(Int, split("3,9,8,9,10,9,4,9,99,-1,8", ","))
    @test AdventOfCode2019.Day05._run_program(copy(inp), [8])[end] == 1
    @test AdventOfCode2019.Day05._run_program(copy(inp), [9])[end] == 0

    inp = parse.(Int, split("3,9,7,9,10,9,4,9,99,-1,8", ","))
    @test AdventOfCode2019.Day05._run_program(copy(inp), [7])[end] == 1
    @test AdventOfCode2019.Day05._run_program(copy(inp), [8])[end] == 0
    @test AdventOfCode2019.Day05._run_program(copy(inp), [9])[end] == 0

    inp = parse.(Int, split("3,3,1108,-1,8,3,4,3,99", ","))
    @test AdventOfCode2019.Day05._run_program(copy(inp), [8])[end] == 1
    @test AdventOfCode2019.Day05._run_program(copy(inp), [9])[end] == 0

    inp = parse.(Int, split("3,3,1107,-1,8,3,4,3,99", ","))
    @test AdventOfCode2019.Day05._run_program(copy(inp), [7])[end] == 1
    @test AdventOfCode2019.Day05._run_program(copy(inp), [8])[end] == 0
    @test AdventOfCode2019.Day05._run_program(copy(inp), [9])[end] == 0

    inp = parse.(Int, split("3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9", ","))
    @test AdventOfCode2019.Day05._run_program(copy(inp), [0])[end] == 0
    @test AdventOfCode2019.Day05._run_program(copy(inp), [-1])[end] == 1
    @test AdventOfCode2019.Day05._run_program(copy(inp), [1])[end] == 1

    inp = parse.(Int, split("3,3,1105,-1,9,1101,0,0,12,4,12,99,1", ","))
    @test AdventOfCode2019.Day05._run_program(copy(inp), [0])[end] == 0
    @test AdventOfCode2019.Day05._run_program(copy(inp), [-1])[end] == 1
    @test AdventOfCode2019.Day05._run_program(copy(inp), [1])[end] == 1

    inp = parse.(Int, split("3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99", ","))
    @test AdventOfCode2019.Day05._run_program(copy(inp), [7])[end] == 999
    @test AdventOfCode2019.Day05._run_program(copy(inp), [8])[end] == 1000
    @test AdventOfCode2019.Day05._run_program(copy(inp), [9])[end] == 1001

    @test AdventOfCode2019.Day05.day05() == [7566643, 9265694]
end

@testset "Day 6" begin
    @test AdventOfCode2019.Day06.day06("COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L\nK)YOU\nI)SAN") == [54, 4]
    @test AdventOfCode2019.Day06.day06() == [194721, 316]
end

@testset "Day 7" begin
    inp = parse.(Int, split("3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0", ","))
    @test AdventOfCode2019.Day07.run_amplifiers(inp, [4, 3, 2, 1, 0], 0) == 43210

    inp = parse.(Int, split("3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0", ","))
    @test AdventOfCode2019.Day07.run_amplifiers(inp, [0, 1, 2, 3, 4], 0) == 54321

    inp = parse.(Int, split("3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0", ","))
    @test AdventOfCode2019.Day07.run_amplifiers(inp, [1, 0, 4, 3, 2], 0) == 65210

    inp = parse.(Int, split("3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5", ","))
    @test AdventOfCode2019.Day07.run_feedback_loop(inp, [9, 8, 7, 6, 5], 0) == 139629729

    inp = parse.(Int, split("3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10", ","))
    @test AdventOfCode2019.Day07.run_feedback_loop(inp, [9, 7, 8, 5, 6], 0) == 18216

    @test AdventOfCode2019.Day07.day07() == [844468, 4215746]
end

@testset "Day 8" begin
    part1, imagecode = AdventOfCode2019.Day08.day08()
    @test part1 == 2375
    image = AdventOfCode2019.Day08.generate_image(imagecode)
    expected = "███  █  █ █  █ ███  █   █\n" *
               "█  █ █ █  █  █ █  █ █   █\n" *
               "█  █ ██   ████ █  █  █ █ \n" *
               "███  █ █  █  █ ███    █  \n" *
               "█ █  █ █  █  █ █ █    █  \n" *
               "█  █ █  █ █  █ █  █   █  \n"
    @test image == expected
end
