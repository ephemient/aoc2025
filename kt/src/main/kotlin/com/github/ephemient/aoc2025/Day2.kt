package com.github.ephemient.aoc2025

fun day2(input: String, maxSplit: Int): Long {
    return input.trim().split(',').sumOf { range ->
        val split = range.indexOf('-')
        val loString = range.take(split)
        val lo = loString.toLong()
        val hiString = range.drop(split + 1)
        val hi = hiString.toLong()
        val found = mutableSetOf<Long>()
        for (n in 2..maxOf(loString.length, hiString.length).coerceAtMost(maxSplit)) {
            val loChunk = if (loString.length % n == 0) {
                loString.take(loString.length / n).toInt()
            } else {
                "1".padEnd(loString.length / n + 1, '0').toInt()
            }
            val hiChunk = if (hiString.length % n == 0) {
                hiString.take(hiString.length / n).toInt()
            } else {
                "1".padEnd(hiString.length / n + 1, '0').toInt() - 1
            }
            for (chunk in loChunk..hiChunk) {
                val candidate = buildString { repeat(n) { append(chunk) } }.toLong()
                if (candidate in lo..hi) found.add(candidate)
            }
        }
        found.sum()
    }
}
