package com.github.ephemient.aoc2025

object Day11 {
    private fun parse(input: String): Map<String, List<String>> = input.lines().mapNotNull { line ->
        val split = line.indexOf(':')
        if (split == -1) null else line.take(split) to line.drop(split + 1).split(' ')
    }.toMap()

    private fun Map<String, Iterable<String>>.paths(src: String, dst: String): Int {
        val cache = mutableMapOf(dst to 1)
        return DeepRecursiveFunction { key ->
            cache.getOrPut(key) { get(key)?.sumOf { this.callRecursive(it) } ?: 0 }
        }(src)
    }

    fun part1(input: String): Int = parse(input).paths("you", "out")

    fun part2(input: String): Long = with(parse(input)) {
        paths("svr", "dac").toLong() * paths("dac", "fft") * paths("fft", "out") +
                paths("svr", "fft").toLong() * paths("fft", "dac") * paths("dac", "out")
    }
}
