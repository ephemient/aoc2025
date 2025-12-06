use std::ops::{Add, Mul};

fn ops(ops: &str) -> Vec<fn(usize, usize) -> usize> {
    ops.chars()
        .filter_map(|op| -> Option<fn(usize, usize) -> usize> {
            match op {
                '+' => Some(usize::add),
                '*' => Some(usize::mul),
                _ => None,
            }
        })
        .collect()
}

pub fn part1(input: &str) -> usize {
    let mut lines = input.lines().collect::<Vec<_>>();
    let ops = ops(lines.pop().unwrap_or_default());
    let mut lines = lines
        .into_iter()
        .map(|line| line.split_ascii_whitespace())
        .collect::<Vec<_>>();
    ops.into_iter()
        .filter_map(|op| {
            lines
                .iter_mut()
                .filter_map(|iter| iter.next()?.parse::<usize>().ok())
                .reduce(op)
        })
        .sum()
}

pub fn part2(input: &str) -> usize {
    let mut lines = input.lines().collect::<Vec<_>>();
    let ops = ops(lines.pop().unwrap_or_default());
    let mut lines = lines
        .into_iter()
        .map(|line| line.chars())
        .collect::<Vec<_>>();
    ops.into_iter()
        .filter_map(|op| {
            std::iter::from_fn(|| {
                lines
                    .iter_mut()
                    .map(|iter| iter.next().unwrap_or(' '))
                    .collect::<String>()
                    .trim_ascii()
                    .parse::<usize>()
                    .ok()
            })
            .reduce(op)
        })
        .sum()
}
