package com.github.ephemient.aoc2025

import kotlinx.benchmark.Benchmark
import kotlinx.benchmark.Scope
import kotlinx.benchmark.Setup
import kotlinx.benchmark.State

@State(Scope.Benchmark)
open class Day1Bench {
    private lateinit var input: String

    @Setup
    fun setup() {
        input = getDayInput(1)
    }

    @Benchmark
    fun solve() = day1(input)
}
