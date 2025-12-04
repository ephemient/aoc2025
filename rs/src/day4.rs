use std::cell::Cell;
use std::collections::{HashMap, hash_map::Entry};

pub fn solve(input: &str) -> (usize, usize) {
    let mut points = input
        .lines()
        .enumerate()
        .flat_map(|(y, line)| {
            line.char_indices().filter_map(move |(x, c)| {
                if c == '@' {
                    Some(((x, y), Cell::new(-1)))
                } else {
                    None
                }
            })
        })
        .collect::<HashMap<_, _>>();
    for (x, y) in points.keys() {
        for x in x.saturating_sub(1)..=x.saturating_add(1) {
            for y in y.saturating_sub(1)..=y.saturating_add(1) {
                if let Some(cell) = points.get(&(x, y)) {
                    cell.update(|count| count + 1);
                }
            }
        }
    }
    let mut removals = points
        .extract_if(|_, count| count.get() < 4)
        .map(|(point, _)| point)
        .collect::<Vec<_>>();
    let (part1, mut part2) = (removals.len(), 0);
    while let Some((x, y)) = removals.pop() {
        part2 += 1;
        for x in x.saturating_sub(1)..=x.saturating_add(1) {
            for y in y.saturating_sub(1)..=y.saturating_add(1) {
                match points.entry((x, y)) {
                    Entry::Occupied(entry) => {
                        entry.get().update(|count| count - 1);
                        if entry.get().get() < 4 {
                            removals.push(entry.remove_entry().0);
                        }
                    }
                    Entry::Vacant(_) => {}
                }
            }
        }
    }
    (part1, part2)
}
