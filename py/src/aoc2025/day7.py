from collections import defaultdict


def _day7(input: str) -> tuple[int, int]:
    first, *lines = input.splitlines()
    count, total = 0, defaultdict(int, {i: 1 for i, c in enumerate(first) if c == "S"})
    for line in lines:
        prev, total = total, defaultdict(int)
        for i, n in prev.items():
            if line[i : i + 1] == "^":
                count += 1
                total[i - 1] += n
                total[i + 1] += n
            else:
                total[i] += n
    return count, sum(total.values())


parts = (_day7,)
