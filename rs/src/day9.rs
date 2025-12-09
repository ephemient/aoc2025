use std::cmp::{max, min};
use std::collections::{BTreeMap, BTreeSet};

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
                .map(|&(x2, y2)| (x1.abs_diff(x2) + 1) * (y1.abs_diff(y2) + 1))
        })
        .max()
        .unwrap_or_default()
}

pub fn part2(input: &str) -> usize {
    let input = parse(input);

    let (ix, iy): (BTreeSet<_>, BTreeSet<_>) = input.iter().copied().unzip();
    let ix: BTreeMap<_, _> = ix.into_iter().enumerate().map(|(i, x)| (x, i)).collect();
    let iy: BTreeMap<_, _> = iy.into_iter().enumerate().map(|(i, y)| (y, i)).collect();
    let mut fill = vec![vec![true; 2 * ix.len() + 1]; 2 * iy.len() + 1];
    for ((x1, y1), (x2, y2)) in input.iter().zip(input.iter().cycle().skip(1)) {
        if x1 == x2 {
            let ix = 2 * ix[x1] + 1;
            let (iy1, iy2) = (2 * iy[y1] + 1, 2 * iy[y2] + 1);
            for iy in min(iy1, iy2)..=max(iy1, iy2) {
                fill[iy][ix] = false;
            }
        } else if y1 == y2 {
            let iy = 2 * iy[y1] + 1;
            let (ix1, ix2) = (2 * ix[x1] + 1, 2 * ix[x2] + 1);
            for ix in min(ix1, ix2)..=max(ix1, ix2) {
                fill[iy][ix] = false;
            }
        }
    }
    assert!(fill[0][0]);
    fill[0][0] = false;
    let mut queue = vec![(0usize, 0usize)];
    while let Some((ix, iy)) = queue.pop() {
        for (ix, iy) in [
            (ix.checked_sub(1), Some(iy)),
            (Some(ix + 1).filter(|ix| *ix < fill[iy].len()), Some(iy)),
            (Some(ix), iy.checked_sub(1)),
            (Some(ix), Some(iy + 1).filter(|iy| *iy < fill.len())),
        ] {
            if let Some(ix) = ix
                && let Some(iy) = iy
                && fill[iy][ix]
            {
                fill[iy][ix] = false;
                queue.push((ix, iy));
            }
        }
    }
    for ((x1, y1), (x2, y2)) in input.iter().zip(input.iter().cycle().skip(1)) {
        if x1 == x2 {
            let ix = 2 * ix[x1] + 1;
            let (iy1, iy2) = (2 * iy[y1] + 1, 2 * iy[y2] + 1);
            for iy in min(iy1, iy2)..=max(iy1, iy2) {
                fill[iy][ix] = true;
            }
        } else if y1 == y2 {
            let iy = 2 * iy[y1] + 1;
            let (ix1, ix2) = (2 * ix[x1] + 1, 2 * ix[x2] + 1);
            for ix in min(ix1, ix2)..=max(ix1, ix2) {
                fill[iy][ix] = true;
            }
        }
    }

    input
        .iter()
        .enumerate()
        .flat_map(|(i, (x1, y1))| {
            let (ix, iy) = (&ix, &iy);
            let (ix1, iy1) = (2 * ix[x1] + 1, 2 * iy[y1] + 1);
            input[..i].iter().map(move |(x2, y2)| {
                let (ix2, iy2) = (2 * ix[x2] + 1, 2 * iy[y2] + 1);
                (
                    (x1.abs_diff(*x2) + 1) * (y1.abs_diff(*y2) + 1),
                    (min(ix1, ix2), min(iy1, iy2)),
                    (max(ix1, ix2), max(iy1, iy2)),
                )
            })
        })
        .fold(0, |acc, (area, (ix1, iy1), (ix2, iy2))| {
            if acc < area && (ix1..=ix2).all(|ix| (iy1..=iy2).all(|iy| fill[iy][ix])) {
                area
            } else {
                acc
            }
        })
}
