package com.github.ephemient.aoc2025

object Day3 {
    fun day3(input: String, digits: Int): Long = input.lines().sumOf { line ->
        if (line.length < digits) return@sumOf 0
        var startIndex = 0
        var acc = 0L
        for (i in 1..digits) {
            val c = line.substring(startIndex, line.length - digits + i).max()
            startIndex = line.indexOf(c, startIndex) + 1
            acc = 10 * acc + c.digitToInt()
        }
        acc
    }

    fun part1(input: String): Long = day3(input, 2)
    fun part2(input: String): Long = day3(input, 12)
}
