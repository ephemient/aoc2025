package com.github.ephemient.aoc2025

interface IntervalSet<T> {
    fun addRange(start: T, endInclusive: T)
    operator fun contains(element: T): Boolean
    fun containsAny(start: T, endInclusive: T): Boolean
    val size: T
}

abstract class IntervalSetImpl<T : Comparable<T>, R : ClosedRange<T>>(
    protected val intervals: MutableList<R>,
) : IntervalSet<T> {
    override fun addRange(start: T, endInclusive: T) {
        val i = intervals.binarySearch { compareValues(it.endInclusive, start) }
            .let { it xor it.shr(Int.SIZE_BITS - 1) }
        val j = intervals.binarySearch(fromIndex = i) { compareValues(it.start, endInclusive) }
            .let { it xor it.shr(Int.SIZE_BITS - 1) }
        if (i < j) {
            intervals[i] = minOf(intervals[i].start, start)..maxOf(intervals[j - 1].endInclusive, endInclusive)
            intervals.subList(i + 1, j).clear()
        } else {
            intervals.add(i, start..endInclusive)
        }
    }

    override fun contains(element: T): Boolean {
        val i = intervals.binarySearch { compareValues(it.endInclusive, element) }
            .let { it xor it.shr(Int.SIZE_BITS - 1) }
        return i <= intervals.lastIndex && intervals[i].start <= element
    }

    override fun containsAny(start: T, endInclusive: T): Boolean {
        val i = intervals.binarySearch { compareValues(it.endInclusive, start) }
            .let { it xor it.shr(Int.SIZE_BITS - 1) }
        val j = intervals.binarySearch(fromIndex = i) { compareValues(it.start, endInclusive) }
            .let { it xor it.shr(Int.SIZE_BITS - 1) }
        return i < j
    }

    protected abstract operator fun T.rangeTo(other: T): R
}

class IntIntervalSet private constructor(
    intervals: MutableList<IntRange>,
) : IntervalSetImpl<Int, IntRange>(intervals) {
    constructor() : this(mutableListOf())
    constructor(intervals: Iterable<IntRange>) : this(
        intervals.toMutableList().apply {
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
    )
    override val size get() = intervals.sumOf { it.last - it.first + 1}
    override fun Int.rangeTo(other: Int) = IntRange(this, other)
}

class LongIntervalSet private constructor(
    intervals: MutableList<LongRange>,
) : IntervalSetImpl<Long, LongRange>(intervals) {
    constructor() : this(mutableListOf())
    constructor(intervals: Iterable<LongRange>) : this(
        intervals.toMutableList().apply {
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
    )
    override val size get() = intervals.sumOf { it.last - it.first + 1}
    override fun Long.rangeTo(other: Long) = LongRange(this, other)
}
