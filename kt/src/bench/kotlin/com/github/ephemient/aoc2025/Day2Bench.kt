package com.github.ephemient.aoc2025

import kotlinx.benchmark.Benchmark
import kotlinx.benchmark.Scope
import kotlinx.benchmark.Setup
import kotlinx.benchmark.State

@State(Scope.Benchmark)
open class Day2Bench {
    private lateinit var input: String

    @Setup
    fun setup() {
        input = getDayInput(2)
    }

    @Benchmark
    fun part1() = Day2.part1(input)

    @Benchmark
    fun part2() = Day2.part2(input)
}
