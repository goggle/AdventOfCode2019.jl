[![CI](https://github.com/goggle/AdventOfCode2019.jl/workflows/CI/badge.svg)](https://github.com/goggle/AdventOfCode2019.jl/actions?query=workflow%3ACI+branch%3Amaster)
[![Code coverage](https://codecov.io/gh/goggle/AdventOfCode2019.jl/branch/master/graphs/badge.svg?branch=master)](https://codecov.io/github/goggle/AdventOfCode2019.jl?branch=master)

# AdventOfCode2019.jl

This Julia package contains my solutions for [Advent of Code 2019](https://adventofcode.com/2019/).

## Overview

| Day | Problem | Time | Allocated memory | Intcode Challenge | Source |
|----:|:-------:|-----:|-----------------:|:-----------------:|:------:|
| 1 |  [:white_check_mark:](https://adventofcode.com/2019/day/1) | 18.415 μs | 10.98 KiB | | [:white_check_mark:](https://github.com/goggle/AdventOfCode2019.jl/blob/master/src/day01/day01.jl) |
| 2 |  [:white_check_mark:](https://adventofcode.com/2019/day/2) | 1.363 ms | 10.80 KiB | :white_check_mark: | [:white_check_mark:](https://github.com/goggle/AdventOfCode2019.jl/blob/master/src/day02/day02.jl) |
| 2 |  [:white_check_mark:](https://adventofcode.com/2019/day/3) | 445.030 μs | 209.16 KiB | | [:white_check_mark:](https://github.com/goggle/AdventOfCode2019.jl/blob/master/src/day03/day03.jl) |
| 4 |  [:white_check_mark:](https://adventofcode.com/2019/day/4) | 24.145 μs | 576 bytes | | [:white_check_mark:](https://github.com/goggle/AdventOfCode2019.jl/blob/master/src/day04/day04.jl) |
| 5 |  [:white_check_mark:](https://adventofcode.com/2019/day/5) | 81.015 μs | 57.17 KiB | :white_check_mark: | [:white_check_mark:](https://github.com/goggle/AdventOfCode2019.jl/blob/master/src/day05/day05.jl) |
| 6 |  [:white_check_mark:](https://adventofcode.com/2019/day/6) | 173.107 ms | 193.03 MiB | | [:white_check_mark:](https://github.com/goggle/AdventOfCode2019.jl/blob/master/src/day06/day06.jl) |
| 7 |  [:white_check_mark:](https://adventofcode.com/2019/day/7) | 10.347 ms | 9.21 MiB | :white_check_mark: | [:white_check_mark:](https://github.com/goggle/AdventOfCode2019.jl/blob/master/src/day07/day07.jl) |
| 8 |  [:white_check_mark:](https://adventofcode.com/2019/day/8) | 1.626 ms | 2.97 MiB | | [:white_check_mark:](https://github.com/goggle/AdventOfCode2019.jl/blob/master/src/day08/day08.jl) |
| 9 |  [:white_check_mark:](https://adventofcode.com/2019/day/9) | 23.784 ms | 72.92 KiB | :white_check_mark: | [:white_check_mark:](https://github.com/goggle/AdventOfCode2019.jl/blob/master/src/day09/day09.jl) |
| 10 | [:white_check_mark:](https://adventofcode.com/2019/day/10) | 253.410 ms | 62.58 MiB | | [:white_check_mark:](https://github.com/goggle/AdventOfCode2019.jl/blob/master/src/day10/day10.jl) |
| 11 | [:white_check_mark:](https://adventofcode.com/2019/day/11) | 61.687 ms | 1.73 MiB | :white_check_mark: | [:white_check_mark:](https://github.com/goggle/AdventOfCode2019.jl/blob/master/src/day11/day11.jl) |
| 12 | [:white_check_mark:](https://adventofcode.com/2019/day/12) | 109.007 ms | 187.87 MiB | | [:white_check_mark:](https://github.com/goggle/AdventOfCode2019.jl/blob/master/src/day12/day12.jl) |
| 13 | [:white_check_mark:](https://adventofcode.com/2019/day/13) | 76.086 ms | 712.30 KiB | :white_check_mark: | [:white_check_mark:](https://github.com/goggle/AdventOfCode2019.jl/blob/master/src/day13/day13.jl) |
| 14 | [:white_check_mark:](https://adventofcode.com/2019/day/14) | 2.650 ms | 964.63 KiB | | [:white_check_mark:](https://github.com/goggle/AdventOfCode2019.jl/blob/master/src/day14/day14.jl) |
| 15 | [:white_check_mark:](https://adventofcode.com/2019/day/15) | 11.352 ms | 318.86 KiB | :white_check_mark: | [:white_check_mark:](https://github.com/goggle/AdventOfCode2019.jl/blob/master/src/day15/day15.jl) |
| 16 | [:white_check_mark:](https://adventofcode.com/2019/day/16) | 302.481 ms | 52.11 MiB | | [:white_check_mark:](https://github.com/goggle/AdventOfCode2019.jl/blob/master/src/day16/day16.jl) |
| 17 | [:white_check_mark:](https://adventofcode.com/2019/day/17) | 31.891 ms | 4.22 MiB | :white_check_mark: | [:white_check_mark:](https://github.com/goggle/AdventOfCode2019.jl/blob/master/src/day17/day17.jl) |
| 18 | [:white_check_mark:](https://adventofcode.com/2019/day/18) | 1.228 s | 678.39 MiB | | [:white_check_mark:](https://github.com/goggle/AdventOfCode2019.jl/blob/master/src/day18/day18.jl) |
| 19 | [:white_check_mark:](https://adventofcode.com/2019/day/19) | 2.356 s | 185.80 MiB | :white_check_mark: | [:white_check_mark:](https://github.com/goggle/AdventOfCode2019.jl/blob/master/src/day19/day19.jl) |
| 20 | [:white_check_mark:](https://adventofcode.com/2019/day/20) | 1.081 s | 436.88 MiB | | [:white_check_mark:](https://github.com/goggle/AdventOfCode2019.jl/blob/master/src/day20/day20.jl) |
| 21 | [:white_check_mark:](https://adventofcode.com/2019/day/21) | 35.018 ms | 280.50 KiB | :white_check_mark: | [:white_check_mark:](https://github.com/goggle/AdventOfCode2019.jl/blob/master/src/day21/day21.jl) |
| 22 | [:white_check_mark:](https://adventofcode.com/2019/day/22) | 136.020 μs | 96.19 KiB | | [:white_check_mark:](https://github.com/goggle/AdventOfCode2019.jl/blob/master/src/day22/day22.jl) |
| 23 | [:white_check_mark:](https://adventofcode.com/2019/day/23) | 14.125 ms | 2.17 MiB | :white_check_mark: | [:white_check_mark:](https://github.com/goggle/AdventOfCode2019.jl/blob/master/src/day23/day23.jl) |
| 24 | [:white_check_mark:](https://adventofcode.com/2019/day/24) | 67.635 ms | 10.39 MiB | | [:white_check_mark:](https://github.com/goggle/AdventOfCode2019.jl/blob/master/src/day24/day24.jl) |
| 25 | [:white_check_mark:](https://adventofcode.com/2019/day/25) | 291.869 ms | 2.58 MiB | :white_check_mark: | [:white_check_mark:](https://github.com/goggle/AdventOfCode2019.jl/blob/master/src/day25/day25.jl) |


The benchmarks have been measured on this machine:
```
Platform Info:
  OS: Linux (x86_64-pc-linux-gnu)
  CPU: Intel(R) Core(TM) i7-3770 CPU @ 3.40GHz
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-6.0.1 (ORCJIT, ivybridge)
```


## Installation and Usage

Make sure you have [Julia 1.3 or newer](https://julialang.org/downloads/)
installed on your system.


### Installation

Start Julia and enter the package REPL by typing `]`. Create a new
environment:
```julia
(v1.3) pkg> activate aoc
```

Install `AdventOfCode2019.jl`:
```
(aoc) pkg> add https://github.com/goggle/AdventOfCode2019.jl
```

Go back to the Julia REPL by pushing the `backspace` button.


### Usage

First, activate the package:
```julia
julia> using AdventOfCode2019
```

Each puzzle can now be run with `dayXY()`:
```julia
julia> day09()
2-element Array{Int64,1}:
 3601950151
      64236
```

This will use my personal input. If you want to use another input, provide it
to the `dayXY` method as a string. You can also use the `readInput` method
to read your input from a text file:
```julia
julia> input = readInput("/path/to/input.txt")
```

