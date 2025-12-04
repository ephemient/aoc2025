use std::collections::HashSet;

pub fn solve(input: &str) -> (usize, usize) {
    let mut points = input
        .lines()
        .enumerate()
        .flat_map(|(y, line)| {
            line.char_indices()
                .filter_map(move |(x, c)| if c == '@' { Some((x, y)) } else { None })
        })
        .collect::<HashSet<_>>();
    let initial = points.len();
    let mut changed = step(&mut points);
    let part1 = initial - points.len();
    while changed {
        changed = step(&mut points);
    }
    (part1, initial - points.len())
}

fn step(points: &mut HashSet<(usize, usize)>) -> bool {
    let old_points = points.clone();
    points
        .extract_if(|(x, y)| {
            (x.saturating_sub(1)..=x.saturating_add(1))
                .flat_map(|x| (y.saturating_sub(1)..=y.saturating_add(1)).map(move |y| (x, y)))
                .filter(|point| old_points.contains(point))
                .count()
                <= 4
        })
        .last()
        .is_some()
}
