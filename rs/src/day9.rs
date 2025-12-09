use std::cmp::{max, min};
use std::collections::BTreeMap;
use std::ops::Bound::Excluded;

fn parse(input: &str) -> Vec<(isize, isize)> {
    input
        .lines()
        .filter_map(|line| {
            let (left, right) = line.split_once(',')?;
            Some((left.parse().ok()?, right.parse().ok()?))
        })
        .collect::<Vec<_>>()
}

pub fn part1(input: &str) -> usize {
    let input = parse(input);
    input
        .iter()
        .enumerate()
        .flat_map(|(i, (x1, y1))| {
            input[..i]
                .iter()
                .map(|(x2, y2)| (x1.abs_diff(*x2) + 1) * (y1.abs_diff(*y2) + 1))
        })
        .max()
        .unwrap_or_default()
}

pub fn part2(input: &str) -> usize {
    let input = parse(input);

    let (mut xs, mut ys) = (BTreeMap::new(), BTreeMap::new());
    for (&(x1, y1), &(x2, y2)) in input.iter().zip(input.iter().cycle().skip(1)) {
        debug_assert!(x1 == x2 || y1 == y2);
        if x1 == x2 {
            xs.entry(x1)
                .or_insert_with(|| vec![])
                .push((min(y1, y2), max(y1, y2)));
        }
        if y1 == y2 {
            ys.entry(y1)
                .or_insert_with(|| vec![])
                .push((min(x1, x2), max(x1, x2)));
        }
    }

    input
        .iter()
        .enumerate()
        .flat_map(|(i, &(x1, y1))| {
            input[..i]
                .iter()
                .map(move |&(x2, y2)| ((x1.min(x2), y1.min(y2)), (x1.max(x2), y1.max(y2))))
        })
        .fold(0, |acc, ((x1, y1), (x2, y2))| {
            let area = (x1.abs_diff(x2) + 1) * (y1.abs_diff(y2) + 1);
            if acc < area
                && (x1 == x2
                    || xs
                        .range((Excluded(x1), Excluded(x2)))
                        .all(|(_, ys)| ys.iter().any(|&(lo, hi)| y2 <= lo || hi <= y1)))
                && (y1 == y2
                    || ys
                        .range((Excluded(y1), Excluded(y2)))
                        .all(|(_, xs)| xs.iter().any(|&(lo, hi)| x2 <= lo || hi <= x1)))
            {
                area
            } else {
                acc
            }
        })
}
