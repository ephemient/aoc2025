package com.github.ephemient.aoc2025

import kotlinx.benchmark.Benchmark
import kotlinx.benchmark.Scope
import kotlinx.benchmark.Setup
import kotlinx.benchmark.State

@State(Scope.Benchmark)
open class Day4Bench {
    private lateinit var input: String

    @Setup
    fun setup() {
        input = getDayInput(4)
    }

    @Benchmark
    fun solve() = day4(input)
}
