use std::cmp::{Reverse, max, min};

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
                (
                    i,
                    j,
                    a.iter()
                        .zip(b.iter())
                        .map(|(a, b)| {
                            let d = a.abs_diff(*b);
                            d * d
                        })
                        .sum::<usize>(),
                )
            })
        })
        .collect::<Vec<_>>();
    edges.sort_unstable_by_key(|(_, _, d)| *d);
    let mut part1 = 0;
    let mut components = nodes.len();
    let mut mapping = Mapping((0..nodes.len()).collect());
    for (m, (i, j, _)) in edges.into_iter().enumerate() {
        let (a, b) = (mapping.lookup(i), mapping.lookup(j));
        if a != b {
            mapping.0[max(a, b)] = min(a, b);
            components -= 1;
        }
        if m + 1 == n {
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
}
