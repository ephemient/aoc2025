use std::cmp::Reverse;

fn day3(input: &str, digits: usize) -> usize {
    input
        .lines()
        .filter_map(|line| {
            if line.len() < digits {
                return None;
            }
            let line = line.as_bytes();
            let mut start = 0;
            let mut acc = 0;
            for n in (0..digits).rev() {
                let (i, b) = line[start..line.len() - n]
                    .iter()
                    .enumerate()
                    .min_by_key(|(_, b)| Reverse(**b))?;
                start += i + 1;
                acc = 10 * acc + (*b as char).to_digit(10)? as usize;
            }
            Some(acc)
        })
        .sum::<usize>()
}

pub fn part1(input: &str) -> usize {
    day3(input, 2)
}

pub fn part2(input: &str) -> usize {
    day3(input, 12)
}
