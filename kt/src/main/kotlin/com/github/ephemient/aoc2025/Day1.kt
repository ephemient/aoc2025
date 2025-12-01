package com.github.ephemient.aoc2025

import kotlin.math.abs
import kotlin.math.sign

fun day1(input: String): Pair<Int, Int> {
    var zeros = 0
    var turns = 0
    input.lines().fold(50) { pos, line ->
        val rotation = when (line.firstOrNull()) {
            'L' -> -line.drop(1).toInt()
            'R' -> line.drop(1).toInt()
            else -> return@fold pos
        }
        val pos2 = pos + rotation
        turns += abs(pos2 - rotation.sign) / 100
        if (pos != 0 && pos2 < 0) turns++
        pos2.mod(100).also { if (it == 0) zeros++ }
    }
    return zeros to zeros + turns
}
