from collections import defaultdict
from heapq import heappop, heappush
from math import prod


def _day8(input: str, n: int = 1000) -> tuple[int, int | None]:
    nodes = [tuple(map(int, line.split(","))) for line in input.splitlines()]
    part1 = 0
    components = len(nodes)
    mapping = {}
    edges = []
    for i, node in enumerate(nodes):
        for j in range(i + 1, len(nodes)):
            heappush(
                edges, (sum((a - b) * (a - b) for a, b in zip(node, nodes[j])), i, j)
            )

    def lookup(key: int) -> int:
        if key not in mapping:
            return key
        value = lookup(mapping[key])
        mapping[key] = value
        return value

    for m in range(len(edges)):
        _, i, j = heappop(edges)
        a, b = lookup(i), lookup(j)
        if a != b:
            mapping[max(a, b)] = min(a, b)
            components -= 1
        if m + 1 == n:
            groupings = defaultdict(set)
            for key in range(len(nodes)):
                groupings[lookup(key)].add(key)
            if len(groupings) >= 3:
                part1 = prod(sorted(map(len, groupings.values()))[-3:])
        if components == 1:
            return part1, nodes[i][0] * nodes[j][0]

    return part1, None


parts = (_day8,)
