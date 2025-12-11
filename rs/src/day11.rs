use std::{collections::HashMap, hash::Hash};

fn parse(input: &str) -> HashMap<&str, Vec<&str>> {
    let mut graph = HashMap::new();
    for line in input.lines() {
        let Some((lhs, rhs)) = line.split_once(':') else {
            continue;
        };
        graph
            .entry(lhs)
            .or_insert_with(|| vec![])
            .extend(rhs.split_ascii_whitespace());
    }
    graph
}

struct Paths<'a, K>(&'a HashMap<K, Vec<K>>, HashMap<K, usize>);
impl<'a, K: Copy + Eq + Hash> Paths<'a, K> {
    fn get(&mut self, key: K) -> usize {
        if let Some(result) = self.1.get(&key) {
            return *result;
        }
        let Some(values) = self.0.get(&key) else {
            return 0;
        };
        let result = values.iter().map(|value| self.get(*value)).sum();
        self.1.insert(key, result);
        result
    }
}

fn paths<K: Copy + Eq + Hash>(graph: &HashMap<K, Vec<K>>, src: K, dst: K) -> usize {
    Paths(graph, [(dst, 1)].into_iter().collect()).get(src)
}

pub fn part1(input: &str) -> usize {
    paths(&parse(input), "you", "out")
}

pub fn part2(input: &str) -> usize {
    let graph = parse(input);
    paths(&graph, "svr", "dac") * paths(&graph, "dac", "fft") * paths(&graph, "fft", "out")
        + paths(&graph, "svr", "fft") * paths(&graph, "fft", "dac") * paths(&graph, "dac", "out")
}
