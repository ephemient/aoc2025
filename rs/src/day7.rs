use std::collections::BTreeMap;

pub fn solve(input: &str) -> (usize, usize) {
    let (first, input) = input.split_once('\n').unwrap_or((input, ""));
    let (part1, part2) = input.lines().fold(
        (
            0,
            first
                .bytes()
                .enumerate()
                .filter_map(|(i, c)| if c == b'S' { Some((i, 1)) } else { None })
                .collect::<BTreeMap<_, _>>(),
        ),
        |(mut count, prev), line| {
            let line = line.as_bytes();
            let mut next = BTreeMap::new();
            for (i, n) in prev {
                if line.get(i) == Some(&b'^') {
                    count += 1;
                    next.entry(i.wrapping_sub(1))
                        .and_modify(|m| *m += n)
                        .or_insert(n);
                    next.entry(i.wrapping_add(1))
                        .and_modify(|m| *m += n)
                        .or_insert(n);
                } else {
                    next.entry(i).and_modify(|m| *m += n).or_insert(n);
                }
            }
            (count, next)
        },
    );
    (part1, part2.into_values().sum())
}
