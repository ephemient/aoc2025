package com.github.ephemient.aoc2025

object Day6 {
    private fun day6(input: String, groups: suspend SequenceScope<Iterable<Long>>.(List<String>) -> Unit): Long {
        val lines = input.trimEnd().lines()
        val iterator = iterator { groups(lines.subList(0, lines.lastIndex)) }
        return lines.last().sumOf {
            val op: (Long, Long) -> Long = when (it) {
                ' ' -> return@sumOf 0
                '+' -> Long::plus
                '*' -> Long::times
                else -> throw IllegalArgumentException("Unsupported operation $it")
            }
            iterator.next().reduceOrNull(op) ?: 0
        }
    }

    fun part1(input: String): Long = day6(input) { lines ->
        val nums = lines.map { it.split(' ').mapNotNull(String::toLongOrNull) }
        var i = 0
        while (true) yield(nums.mapNotNull { it.getOrNull(i) }.also { i++ })
    }

    fun part2(input: String): Long = day6(input) { lines ->
        var i = 0
        while (true) yield(
            generateSequence {
                buildString(lines.size) { for (line in lines) append(line.getOrNull(i) ?: ' ') }
                    .trim()
                    .takeIf { it.isNotEmpty() }
                    ?.toLong()
                    .also { i++ }
            }.toList()
        )
    }
}
