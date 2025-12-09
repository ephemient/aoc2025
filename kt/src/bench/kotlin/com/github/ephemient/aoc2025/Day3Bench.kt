package com.github.ephemient.aoc2025

import kotlinx.benchmark.Benchmark
import kotlinx.benchmark.Scope
import kotlinx.benchmark.Setup
import kotlinx.benchmark.State

@State(Scope.Benchmark)
open class Day3Bench {
    private lateinit var input: String

    @Setup
    fun setup() {
        input = getDayInput(3)
    }

    @Benchmark
    fun part1() = Day3.part1(input)

    @Benchmark
    fun part2() = Day3.part2(input)
}
