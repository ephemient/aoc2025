from bisect import bisect_left
from functools import itemgetter
from itertools import takewhile


def _day5(input: str) -> tuple[int, int]:
    lines = iter(input.splitlines())
    ranges = []
    for start, end in sorted(
        (int(r[0]), int(r[1]))
        for line in takewhile(bool, lines)
        if (r := line.split("-", maxsplit=2))
    ):
        ix = bisect_left(ranges, start, key=itemgetter(1))
        if ix < len(ranges):
            ranges[ix:] = [(ranges[ix][0], max(ranges[-1][1], end))]
        else:
            ranges.append((start, end))
    return sum(
        (i := int(line),) and any(i in range(start, end + 1) for start, end in ranges)
        for line in lines
        if line
    ), sum(end - start + 1 for start, end in ranges)


parts = (_day5,)
