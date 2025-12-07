package com.github.ephemient.aoc2025

fun day7(input: String): Pair<Int, Long> {
    val lines = input.lines()
    var part1 = 0
    val part2 = lines.drop(1).fold(
        buildMap {
            lines.firstOrNull()?.forEachIndexed { i, c -> if (c == 'S') put(i, 1L) }
        }
    ) { acc, line ->
        buildMap {
            for ((i, n) in acc) {
                if (line.getOrNull(i) == '^') {
                    part1++
                    add(i - 1, n)
                    add(i + 1, n)
                } else {
                    add(i, n)
                }
            }
        }
    }
    return part1 to part2.values.sum()
}

private fun <K> MutableMap<K, Long>.add(key: K, value: Long) {
    put(key, getOrElse(key) { 0 } + value)
}
