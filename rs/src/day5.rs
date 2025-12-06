use std::cmp::{max, min};

pub fn solve(input: &str) -> (usize, usize) {
    let mut lines = input.lines();
    let mut ranges = Vec::<(usize, usize)>::new();
    for line in lines.by_ref() {
        if let Some((lhs, rhs)) = line.split_once('-')
            && let Ok(lo) = lhs.parse()
            && let Ok(hi) = rhs.parse()
        {
            let i = ranges.partition_point(|range| range.1 < lo);
            let n = ranges[i..].partition_point(|range| range.0 <= hi);
            let range = ranges
                .drain(i..i + n)
                .fold((lo, hi), |(a, b), (c, d)| (min(a, c), max(b, d)));
            ranges.insert(i, range);
        } else {
            break;
        }
    }
    (
        lines
            .filter(|line| {
                if let Ok(id) = line.parse::<usize>() {
                    ranges.iter().any(|(lo, hi)| *lo <= id && id <= *hi)
                } else {
                    false
                }
            })
            .count(),
        ranges.iter().map(|(lo, hi)| hi - lo + 1).sum(),
    )
}
