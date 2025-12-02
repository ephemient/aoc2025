package com.github.ephemient.aoc2025

import java.io.File

val days: Map<String, List<(String) -> Any?>> = mapOf(
    "1" to listOf(::day1),
    "2" to listOf(Day2::part1, Day2::part2),
)

fun main(vararg args: String) {
    val datadir = File(System.getenv("AOC2025_DATADIR")?.ifEmpty { null } ?: ".")
    for ((day, parts) in days.filterKeys(args.toSet()::contains).ifEmpty { days }) {
        println("Day $day")
        val input = File(datadir, "day$day.txt").readText()
        for (part in parts) println(part(input))
        println()
    }
}
