def _day1(input: str) -> tuple[int, int]:
    pos, zeros, turns = 50, 0, 0
    for line in input.splitlines():
        rotation = (
            -int(line[1:])
            if line.startswith("L")
            else int(line[1:])
            if line.startswith("R")
            else None
        )
        if rotation is None:
            continue
        pos2 = pos + rotation
        turns += min(abs(pos2 - 1), abs(pos2 + 1)) // 100
        if pos and pos2 < 0:
            turns += 1
        if not (pos := pos2 % 100):
            zeros += 1
    return zeros, zeros + turns


parts = (_day1,)
