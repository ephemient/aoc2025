from collections.abc import Container
from typing import TypeVar


def _parse(input: str) -> dict[str, list[str]]:
    return {
        line[: (i := line.index(":"))]: line[i + 1 :].split()
        for line in input.splitlines()
        if ":" in line
    }


T = TypeVar("T")


def _paths(graph: dict[T, Container[T]], src: T, dst: T) -> int:
    cache = {dst: 1}

    def get(key: T) -> int:
        if key not in cache:
            cache[key] = sum(map(get, graph.get(key, ())))
        return cache[key]

    return get(src)


def _part1(input: str) -> int:
    return _paths(_parse(input), "you", "out")


def _part2(input: str) -> int:
    graph = _parse(input)
    return _paths(graph, "svr", "dac") * _paths(graph, "dac", "fft") * _paths(
        graph, "fft", "out"
    ) + _paths(graph, "svr", "fft") * _paths(graph, "fft", "dac") * _paths(
        graph, "dac", "out"
    )


parts = (_part1, _part2)
