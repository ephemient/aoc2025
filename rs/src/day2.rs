use std::sync::LazyLock;

fn day2(input: &str, factors: &[(u32, isize)]) -> isize {
    input
        .split(',')
        .filter_map(|range| {
            let (lo, hi) = range.trim().split_once('-')?;
            let lo = lo.parse::<isize>().ok()?;
            let hi = hi.parse::<isize>().ok()?;
            Some(
                factors
                    .iter()
                    .map_while(|(n, c)| {
                        let scale0 = 10isize.pow(*n - 1);
                        let mut power = 1;
                        let mut scale = 1;
                        let mut acc = 0;
                        loop {
                            let prev = power;
                            power *= 10isize;
                            scale *= scale0;
                            if scale > hi {
                                break;
                            }
                            let scale = (scale * power - 1) / (power - 1);
                            let lo = ((lo - 1) / scale).max(prev - 1);
                            let hi = (hi / scale).min(power - 1);
                            if lo < hi {
                                acc += (hi * (hi + 1) - lo * (lo + 1)) / 2 * scale * c;
                            }
                        }
                        Some(acc)
                    })
                    .sum::<isize>(),
            )
        })
        .sum::<isize>()
}

pub fn part1(input: &str) -> isize {
    day2(input, &[(2, 1)])
}

pub fn part2(input: &str) -> isize {
    static FACTORS: LazyLock<Vec<(u32, isize)>> = LazyLock::new(|| {
        let mut factors = vec![];
        for n in 2..=(isize::MAX as f64).log10() as u32 {
            let c = 1 - factors
                .iter()
                .filter_map(|(m, c)| if n % m == 0 { Some(*c) } else { None })
                .sum::<isize>();
            if c != 0 {
                factors.push((n, c));
            }
        }
        factors
    });
    day2(input, &FACTORS)
}
