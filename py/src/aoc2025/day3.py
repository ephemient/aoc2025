from functools import partial


def _day3(input: str, digits: int) -> int:
    total = 0
    for line in input.splitlines():
        acc = 0
        start = 0
        for n in range(digits):
            c = max(line[start : len(line) - digits + n + 1])
            start = line.index(c, start) + 1
            acc = 10 * acc + int(c)
        total += acc
    return total


parts = (partial(_day3, digits=2), partial(_day3, digits=12))
