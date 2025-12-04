def _day4(input: str) -> tuple[int, int]:
    points = {
        (x, y)
        for y, line in enumerate(input.splitlines())
        for x, c in enumerate(line)
        if c == "@"
    }
    initial = len(points)
    step = _step(points)
    part1 = initial - len(step)
    while points != step:
        points, step = step, _step(step)
    return part1, initial - len(points)


def _step(points: set[tuple[int, int]]) -> set[tuple[int, int]]:
    return {
        (x, y)
        for (x, y) in points
        if sum(
            (x2, y2) in points
            for x2 in range(x - 1, x + 2)
            for y2 in range(y - 1, y + 2)
        )
        > 4
    }


parts = (_day4,)
