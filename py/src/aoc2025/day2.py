from cached_iterators import cacheable_iterator
from collections.abc import Generator, Iterable
from functools import partial


def _day2(input: str, factors: Iterable[tuple[int, int]]) -> int:
    acc = 0
    for range in input.strip().split(","):
        lo = int(range[: range.index("-")])
        hi = int(range[range.index("-") + 1 :])
        for n, c in factors:
            scale0 = 10 ** (n - 1)
            if scale0 > hi:
                break
            power = 1
            scale = 1
            while True:
                prev = power
                power *= 10
                scale *= scale0
                if scale > hi:
                    break
                scale2 = (scale * power - 1) // (power - 1)
                start = max((lo - 1) // scale2 + 1, prev)
                stop = min(hi // scale2, power - 1)
                if start <= stop:
                    acc += (stop * (stop + 1) - start * (start - 1)) // 2 * scale2 * c
    return acc


@cacheable_iterator
def _factors() -> Generator[tuple[int, int]]:
    factors = {}
    n = 2
    while True:
        c = 1 - sum(c for m, c in factors.items() if n % m == 0)
        if c:
            yield n, c
            factors[n] = c
        n += 1


parts = (
    partial(_day2, factors=((2, 1),)),
    partial(_day2, factors=_factors()),
)
