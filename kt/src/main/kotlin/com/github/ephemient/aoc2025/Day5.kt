package com.github.ephemient.aoc2025

fun day5(input: String): Pair<Int, Long> {
    val lineIterator = input.lineSequence().iterator()
    val ranges = buildList {
        for (line in lineIterator) {
            if (line.isEmpty()) break
            val (left, right) = line.split('-', limit = 2)
            add(left.toLong()..right.toLong())
        }
        sortBy { it.first }
        var count = 0
        for (range in this) {
            val i = binarySearch(toIndex = count) { compareValues(it.last, range.first) }
                .let { it xor it.shr(Int.SIZE_BITS - 1) }
            this[i] = if (i < count) {
                this[i].first..maxOf(this[i].last, range.last)
            } else {
                range
            }
            count = i + 1
        }
        subList(count, size).clear()
    }
    return Iterable { lineIterator }.count { line ->
        val id = line.toLongOrNull() ?: return@count false
        val ix = ranges.binarySearch { compareValues(it.last, id) }
            .let { it xor it.shr(Int.SIZE_BITS - 1) }
        ix <= ranges.lastIndex && ranges[ix].first <= id
    } to ranges.sumOf { it.last - it.first + 1 }
}
