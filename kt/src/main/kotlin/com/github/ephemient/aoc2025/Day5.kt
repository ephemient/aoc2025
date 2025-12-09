package com.github.ephemient.aoc2025

fun day5(input: String): Pair<Int, Long> {
    val lineIterator = input.lineSequence().iterator()
    val ranges = LongIntervalSet(
        buildList {
            for (line in lineIterator) {
                if (line.isEmpty()) break
                val (left, right) = line.split('-', limit = 2)
                add(left.toLong()..right.toLong())
            }
        }
    )
    return Iterable { lineIterator }.count { line ->
        val id = line.toLongOrNull() ?: return@count false
        id in ranges
    } to ranges.size
}
