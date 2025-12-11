package com.github.ephemient.aoc2025

import kotlinx.benchmark.Benchmark
import kotlinx.benchmark.Scope
import kotlinx.benchmark.Setup
import kotlinx.benchmark.State

@State(Scope.Benchmark)
open class Day11Bench {
    private lateinit var input: String

    @Setup
    fun setup() {
        input = getDayInput(11)
    }

    @Benchmark
    fun part1() = Day11.part1(input)

    @Benchmark
    fun part2() = Day11.part2(input)
}
