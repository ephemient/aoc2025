package com.github.ephemient.aoc2025

fun day4(input: String): Pair<Int, Int> {
    val points = mutableMapOf<Pair<Int, Int>, Int>()
    for ((y, line) in input.lines().withIndex()) {
        for ((x, char) in line.withIndex()) {
            if (char == '@') points[x to y] = -1
        }
    }
    for ((x, y) in points.keys) {
        for (x in x - 1..x + 1) {
            for (y in y - 1..y + 1) {
                points.computeIfPresent(x to y) { _, count -> count + 1}
            }
        }
    }
    val removals = mutableListOf<Pair<Int, Int>>()
    val iterator = points.entries.iterator()
    for ((point, count) in iterator) {
        if (count >= 4) continue
        iterator.remove()
        removals.add(point)
    }
    val part1 = removals.size
    var part2 = 0
    while (true) {
        val (x, y) = removals.removeLastOrNull() ?: break
        part2++
        for (x in x - 1..x + 1) {
            for (y in y - 1..y + 1) {
                points.computeIfPresent(x to y) { key, count ->
                    if (count == 4) removals.add(key)
                    count - 1
                }
            }
        }
    }
    return part1 to part2
}
