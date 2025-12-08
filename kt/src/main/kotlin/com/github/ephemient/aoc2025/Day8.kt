package com.github.ephemient.aoc2025

fun day8(input: String, n: Int = 1000): Pair<Int, Long?> {
    val nodes = input.lines().mapNotNull { line ->
        line.split(',').mapNotNull { it.toLongOrNull() }.ifEmpty { null }
    }
    val edges = buildList {
        for ((i, node) in nodes.withIndex()) {
            for (j in i + 1 ..< nodes.size) {
                add(Triple(i, j, node.zip(nodes[j], Long::minus).sumOf { it * it }))
            }
        }
        sortBy { it.third }
    }
    var components = nodes.size
    val mapping = mutableMapOf<Int, Int>()
    fun lookup(key: Int): Int {
        val value = mapping[key] ?: return key
        return lookup(value).also { mapping[key] = it }
    }
    var part1 = 0
    edges.forEachIndexed { index, (i, j) ->
        val a = lookup(i)
        val b = lookup(j)
        if (a != b) {
            mapping[maxOf(a, b)] = minOf(a, b)
            components--
        }
        if (index + 1 == n) {
            val sizes = nodes.indices.groupingBy(::lookup).fold(0) { acc, _ -> acc + 1 }
            if (sizes.size >= 3) part1 = sizes.values.sorted().takeLast(3).fold(1, Int::times)
        }
        if (components == 1) return part1 to nodes[i][0] * nodes[j][0]
    }
    return part1 to null
}
