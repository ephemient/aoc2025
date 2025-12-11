package com.github.ephemient.aoc2025

import java.io.File

private val days: Map<String, List<(String) -> Any?>> = mapOf(
    "1" to listOf(::day1),
    "2" to listOf(Day2::part1, Day2::part2),
    "3" to listOf(Day3::part1, Day3::part2),
    "4" to listOf(::day4),
    "5" to listOf(::day5),
    "6" to listOf(Day6::part1, Day6::part2),
    "7" to listOf(::day7),
    "8" to listOf { day8(it) },
    "9" to listOf(Day9::part1, Day9::part2),
    "11" to listOf(Day11::part1, Day11::part2),
)

internal fun getDayInput(day: Int): String =
    File(File(System.getenv("AOC2025_DATADIR")?.ifEmpty { null } ?: "."), "day$day.txt").readText()

fun main(vararg args: String) {
    for ((day, parts) in days.filterKeys(args.toSet()::contains).ifEmpty { days }) {
        println("Day $day")
        val input = getDayInput(day.takeWhile(Char::isDigit).toInt())
        for (part in parts) {
            when (val output = part(input)) {
                is Pair<*, *> -> {
                    println(output.first)
                    println(output.second)
                }
                is Triple<*, *, *> -> {
                    println(output.first)
                    println(output.second)
                    println(output.third)
                }
                else -> println(output)
            }
        }
        println()
    }
}
