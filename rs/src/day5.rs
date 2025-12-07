use std::cmp::max;

pub fn solve(input: &str) -> (usize, usize) {
    let mut lines = input.lines();
    let mut ranges = lines
        .by_ref()
        .map_while(|line| {
            let (lhs, rhs) = line.split_once('-')?;
            Some((lhs.parse::<usize>().ok()?, rhs.parse::<usize>().ok()?))
        })
        .collect::<Vec<_>>();
    ranges.sort_unstable();
    let mut count = 0;
    for i in 0..ranges.len() {
        let (lo, hi) = ranges[i];
        let j = ranges[..count]
            .binary_search_by(|range| range.1.cmp(&lo))
            .unwrap_or_else(|j| j);
        let range = &mut ranges[j];
        if j < count {
            range.1 = max(range.1, hi);
        } else {
            *range = (lo, hi);
        }
        count = j + 1;
    }
    ranges.drain(count..);
    (
        lines
            .filter(|line| {
                line.parse().is_ok_and(|id| {
                    !ranges
                        .binary_search_by(|range| range.1.cmp(&id))
                        .is_err_and(|i| ranges.get(i).is_some_and(|range| id < range.0))
                })
            })
            .count(),
        ranges.iter().map(|(lo, hi)| hi - lo + 1).sum(),
    )
}
