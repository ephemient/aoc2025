package com.github.ephemient.aoc2025

fun day5(input: String): Pair<Int, Long> {
    val lineIterator = input.lineSequence().iterator()
    val ranges = mutableListOf<LongRange>()
    for (line in lineIterator) {
        if (line.isEmpty()) break
        val (left, right) = line.split('-', limit = 2)
        val start = left.toLong()
        val end = right.toLong()
        if (ranges.isEmpty()) {
            ranges.add(start..end)
            continue
        }
        val ix1 = ranges.binarySearch { compareValues(it.last, start) }
            .let { if (it < 0) -it - 1 else it }
        val ix2 = ranges.binarySearch(fromIndex = ix1) { compareValues(it.first, end) }
            .let { if (it < 0) -it - 1 else it + 1 }
        if (ix1 < ix2) {
            val first = minOf(ranges[ix1].first, start)
            val last = maxOf(ranges[ix2 - 1].last, end)
            ranges[ix1] = first..last
            ranges.subList(ix1 + 1, ix2).clear()
        } else {
            ranges.add(ix1, start..end)
        }
    }
    return Iterable { lineIterator }.count { line ->
        val id = line.toLongOrNull() ?: return@count false
        val ix = ranges.binarySearch { compareValues(it.last, id) }
            .let { it xor it.shr(Long.SIZE_BITS - 1) }
        ix <= ranges.lastIndex && ranges[ix].first <= id
    } to ranges.sumOf { it.last - it.first + 1 }
}
