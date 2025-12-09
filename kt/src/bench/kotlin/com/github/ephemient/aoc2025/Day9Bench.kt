package com.github.ephemient.aoc2025

import kotlinx.benchmark.Benchmark
import kotlinx.benchmark.Scope
import kotlinx.benchmark.Setup
import kotlinx.benchmark.State

@State(Scope.Benchmark)
open class Day9Bench {
    private lateinit var input: String

    @Setup
    fun setup() {
        input = getDayInput(9)
    }

    @Benchmark
    fun part1() = Day9.part1(input)

    @Benchmark
    fun part2() = Day9.part2(input)
}
