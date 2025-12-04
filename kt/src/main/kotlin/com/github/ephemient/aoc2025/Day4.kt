package com.github.ephemient.aoc2025

fun day4(input: String): Pair<Int, Int> {
    var points = buildSet {
        for ((y, line) in input.lines().withIndex()) {
            for ((x, char) in line.withIndex()) {
                if (char == '@') add(x to y)
            }
        }
    }
    val initial = points.size
    points = step(points) ?: return 0 to 0
    val part1 = initial - points.size
    while (true) points = step(points) ?: break
    return part1 to initial - points.size
}

private fun step(points: Set<Pair<Int, Int>>): Set<Pair<Int, Int>>? = buildSet {
    var found = false
    points.filterTo(this) { (x, y) ->
        val count = (x - 1..x + 1).sumOf { x -> (y - 1..y + 1).count { y -> x to y in points } }
        if (count > 4) {
            true
        } else {
            found = true
            false
        }
    }
    if (!found) return null
}
