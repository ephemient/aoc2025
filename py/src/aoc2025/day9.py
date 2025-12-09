from itertools import chain


def _parse(input: str) -> list[tuple[int, int]]:
    return [
        (int(line[: (i := line.index(","))]), int(line[i + 1 :]))
        for line in input.splitlines()
        if "," in line
    ]


def _part1(input: str) -> int:
    lines = _parse(input)
    return max(
        (
            (abs(x1 - x2) + 1) * (abs(y1 - y2) + 1)
            for i, (x1, y1) in enumerate(lines)
            for x2, y2 in lines[:i]
        ),
        default=0,
    )


def _part2(input: str) -> int:
    lines = _parse(input)
    return max(
        (
            (abs(x1 - x2) + 1) * (abs(y1 - y2) + 1)
            for i, (x1, y1) in enumerate(lines)
            for x2, y2 in lines[:i]
            if all(
                max(x3, x4) <= min(x1, x2)
                or max(x1, x2) <= min(x3, x4)
                or max(y3, y4) <= min(y1, y2)
                or max(y1, y2) <= min(y3, y4)
                for (x3, y3), (x4, y4) in zip(lines, chain(lines[1:], lines[:1]))
            )
        ),
        default=0,
    )


parts = _part1, _part2
