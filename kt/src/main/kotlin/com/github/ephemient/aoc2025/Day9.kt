package com.github.ephemient.aoc2025

import java.util.SortedMap
import java.util.TreeMap
import kotlin.math.abs

object Day9 {
    private fun parse(input: String) = input.lines().mapNotNull { line ->
        val (left, right) = line.split(',', limit = 2)
            .takeIf { it.size == 2 }
            ?: return@mapNotNull null
        val x = left.toIntOrNull() ?: return@mapNotNull null
        val y = right.toIntOrNull() ?: return@mapNotNull null
        x to y
    }

    fun part1(input: String): Int = parse(input).pairs().maxOfOrNull { (a, b) ->
        (abs(a.first - b.first) + 1) * (abs(a.second - b.second) + 1)
    } ?: 0

    fun part2(input: String): Int {
        val points = parse(input)

        val xs: SortedMap<Int, MutableList<Pair<Int, Int>>> = TreeMap()
        val ys: SortedMap<Int, MutableList<Pair<Int, Int>>> = TreeMap()
        for ((i, point1) in points.withIndex()) {
            val point2 = points.getOrNull(i + 1) ?: points.first()
            if (point1.first == point2.first) {
                xs.getOrPut(point1.first) { mutableListOf() }
                    .add(minOf(point1.second, point2.second) to maxOf(point1.second, point2.second))
            }
            if (point1.second == point2.second) {
                ys.getOrPut(point1.second) { mutableListOf() }
                    .add(minOf(point1.first, point2.first) to maxOf(point1.first, point2.first))
            }
        }

        return points.pairs().fold(0) { acc, (left, right) ->
            val area = (abs(left.first - right.first) + 1) * (abs(left.second - right.second) + 1)
            if (acc < area &&
                xs.doesNotIntersect(left.first, left.second, right.first, right.second) &&
                ys.doesNotIntersect(left.second, left.first, right.second, right.first)
            ) area else acc
        }
    }

    private fun <T> List<T>.pairs() = sequence {
        for ((i, y) in this@pairs.withIndex()) {
            for (x in this@pairs.subList(0, i)) {
                yield(x to y)
            }
        }
    }

    private fun SortedMap<Int, out Iterable<Pair<Int, Int>>>.doesNotIntersect(
        key1: Int, value1: Int,
        key2: Int, value2: Int,
    ): Boolean = key1 == key2 || subMap(minOf(key1, key2) + 1, maxOf(key1, key2)).all {
        it.value.all { (value3, value4) ->
            maxOf(value1, value2) <= minOf(value3, value4) ||
                    maxOf(value3, value4) <= minOf(value1, value2)
        }
    }
}
