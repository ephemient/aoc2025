def _day4(input: str) -> tuple[int, int]:
    points = {
        (x, y)
        for y, line in enumerate(input.splitlines())
        for x, c in enumerate(line)
        if c == "@"
    }
    counts = {}
    for x, y in points:
        for x2 in range(x - 1, x + 2):
            for y2 in range(y - 1, y + 2):
                if (x2, y2) in points:
                    counts[(x2, y2)] = counts.get((x2, y2), -1) + 1
    removals = [point for point, count in counts.items() if count < 4]
    points.difference_update(removals)
    part1, part2 = len(removals), 0
    while removals:
        x, y = removals.pop()
        part2 += 1
        for x2 in range(x - 1, x + 2):
            for y2 in range(y - 1, y + 2):
                if (x2, y2) in points:
                    counts[(x2, y2)] -= 1
                    if counts[(x2, y2)] < 4:
                        removals.append((x2, y2))
                        points.remove((x2, y2))
    return part1, part2


parts = (_day4,)
