use std::cmp::{Reverse, max, min};
use std::collections::BinaryHeap;

pub fn solve(input: &str, n: usize) -> (usize, Option<isize>) {
    let nodes = input
        .lines()
        .filter_map(|line| {
            line.split(',')
                .map(|s| s.parse::<isize>())
                .collect::<Result<_, _>>()
                .ok()
        })
        .collect::<Vec<Vec<isize>>>();
    let mut edges = nodes
        .iter()
        .enumerate()
        .flat_map(|(i, a)| {
            nodes.iter().enumerate().skip(i + 1).map(move |(j, b)| {
                let d = a
                    .iter()
                    .zip(b.iter())
                    .map(|(a, b)| {
                        let d = a.abs_diff(*b);
                        d * d
                    })
                    .sum::<usize>();
                (Reverse(d), i, j)
            })
        })
        .collect::<BinaryHeap<_>>();
    let mut index = 0;
    let mut part1 = 0;
    let mut components = nodes.len();
    let mut mapping = Mapping((0..nodes.len()).collect());
    while let Some((_, i, j)) = edges.pop() {
        if mapping.merge(i, j) {
            components -= 1;
        }
        if index + 1 == n {
            let mut counts = vec![0; nodes.len()];
            for key in 0..nodes.len() {
                counts[mapping.lookup(key)] += 1;
            }
            counts.retain(|count| *count > 0);
            if counts.len() >= 3 {
                counts.sort_unstable_by_key(|count| Reverse(*count));
                part1 = counts[..3].iter().product();
            }
        }
        if components == 1 {
            return (part1, Some(nodes[i][0] * nodes[j][0]));
        }
        index += 1;
    }
    (part1, None)
}

struct Mapping(Vec<usize>);
impl Mapping {
    fn lookup(&mut self, key: usize) -> usize {
        let mut value = self.0[key];
        if key != value {
            value = self.lookup(value);
            self.0[key] = value;
        }
        value
    }

    fn merge(&mut self, i: usize, j: usize) -> bool {
        let (a, b) = (self.lookup(i), self.lookup(j));
        self.0[max(a, b)] = min(a, b);
        a != b
    }
}
