package com.github.ephemient.aoc2025

import kotlin.math.log10

object Day2 {
    fun day2(input: String, factors: Map<Int, Int>): Long = input.trim().split(',').sumOf { range ->
        val split = range.indexOf('-')
        val lo = range.take(split).toLong()
        val hi = range.drop(split + 1).toLong()
        var acc = 0L
        for ((n, c) in factors) {
            val scale0 = 10L.pow(n - 1)
            var power = 1L
            var scale = 1L
            while (true) {
                val prev = power
                power *= 10
                scale *= scale0
                if (scale > hi) break
                val scale2 = (scale * power - 1) / (power - 1)
                val startExclusive = ((lo - 1) / scale2).coerceAtLeast(prev - 1)
                val endInclusive = (hi / scale2).coerceAtMost(power - 1)
                if (startExclusive < endInclusive) {
                    acc += (endInclusive * (endInclusive + 1) - startExclusive * (startExclusive + 1)) / 2 * scale2 * c
                }
            }
        }
        acc
    }

    fun part1(input: String): Long = day2(input, factors1)
    fun part2(input: String): Long = day2(input, factors2)

    private val factors1 = mapOf(2 to 1)
    private val factors2 = buildMap<Int, Int> {
        for (n in 2..log10(Long.MAX_VALUE.toDouble()).toInt()) {
            val c = entries.fold(1) { acc, (m, c) -> if (n % m == 0) acc - c else acc }
            if (c != 0) this[n] = c
        }
    }

    private fun Long.pow(x: Int): Long {
        var base = this
        var acc = 1L
        for (i in 0 until Int.SIZE_BITS - x.countLeadingZeroBits()) {
            if (1 shl i and x != 0) acc *= base
            base *= base
        }
        return acc
    }
}
