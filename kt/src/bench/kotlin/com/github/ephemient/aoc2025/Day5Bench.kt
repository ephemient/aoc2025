package com.github.ephemient.aoc2025

import kotlinx.benchmark.Benchmark
import kotlinx.benchmark.Scope
import kotlinx.benchmark.Setup
import kotlinx.benchmark.State

@State(Scope.Benchmark)
open class Day5Bench {
    private lateinit var input: String

    @Setup
    fun setup() {
        input = getDayInput(5)
    }

    @Benchmark
    fun solve() = day5(input)
}
