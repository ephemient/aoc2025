from collections.abc import Callable, Generator, Iterable, Iterator
from functools import partial, reduce
from itertools import zip_longest
from operator import add, mul

_ops = {"+": add, "*": mul}


def _day6(input: str, groups: Callable[[list[str]], Iterable[Iterable[int]]]) -> int:
    lines = input.rstrip().splitlines()
    groups = iter(groups(lines[:-1]))
    return sum(reduce(op, next(groups)) for c in lines[-1] if (op := _ops.get(c)))


def _groups1(lines: list[str]) -> Iterator[Iterable[int]]:
    return zip_longest(*(map(int, line.split()) for line in lines))


def _groups2(lines: list[str]) -> Generator[Iterable[int]]:
    group = []
    for col in zip_longest(*lines):
        col = "".join(col).strip()
        if col:
            group.append(int(col))
        else:
            yield group
            group = []
    yield group


parts = partial(_day6, groups=_groups1), partial(_day6, groups=_groups2)
