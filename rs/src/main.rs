use aoc2025::{day1, day2, day3};
use std::collections::HashSet;
use std::env;
use std::fs;
use std::io;
use std::path::Path;

fn get_day_input(day: u32) -> io::Result<String> {
    let datadir = env::var("AOC2025_DATADIR")
        .ok()
        .filter(|s| !s.is_empty())
        .unwrap_or_else(|| ".".to_string());
    fs::read_to_string(Path::new(&datadir).join(format!("day{}.txt", day)))
}

fn main() -> io::Result<()> {
    let args = env::args().skip(1).collect::<HashSet<_>>();

    if args.is_empty() || args.contains("1") {
        println!("Day 1");
        let input = get_day_input(1)?;
        println!("{:?}", day1::solve(&input));
        println!();
    }

    if args.is_empty() || args.contains("2") {
        println!("Day 2");
        let input = get_day_input(2)?;
        println!("{:?}", day2::part1(&input));
        println!("{:?}", day2::part2(&input));
        println!();
    }

    if args.is_empty() || args.contains("3") {
        println!("Day 3");
        let input = get_day_input(3)?;
        println!("{:?}", day3::part1(&input));
        println!("{:?}", day3::part2(&input));
        println!();
    }

    Ok(())
}
