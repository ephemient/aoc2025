use aoc2025::{day1, day2, day3, day4, day5, day6, day7, day8, day9, day11};
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
        let (part1, part2) = day1::solve(&input);
        println!("{}", part1);
        println!("{}", part2);
        println!();
    }

    if args.is_empty() || args.contains("2") {
        println!("Day 2");
        let input = get_day_input(2)?;
        println!("{}", day2::part1(&input));
        println!("{}", day2::part2(&input));
        println!();
    }

    if args.is_empty() || args.contains("3") {
        println!("Day 3");
        let input = get_day_input(3)?;
        println!("{}", day3::part1(&input));
        println!("{}", day3::part2(&input));
        println!();
    }

    if args.is_empty() || args.contains("4") {
        println!("Day 4");
        let input = get_day_input(4)?;
        let (part1, part2) = day4::solve(&input);
        println!("{}", part1);
        println!("{}", part2);
        println!();
    }

    if args.is_empty() || args.contains("5") {
        println!("Day 5");
        let input = get_day_input(5)?;
        let (part1, part2) = day5::solve(&input);
        println!("{}", part1);
        println!("{}", part2);
        println!();
    }

    if args.is_empty() || args.contains("6") {
        println!("Day 6");
        let input = get_day_input(6)?;
        println!("{}", day6::part1(&input));
        println!("{}", day6::part2(&input));
        println!();
    }

    if args.is_empty() || args.contains("7") {
        println!("Day 7");
        let input = get_day_input(7)?;
        let (part1, part2) = day7::solve(&input);
        println!("{}", part1);
        println!("{}", part2);
        println!();
    }

    if args.is_empty() || args.contains("8") {
        println!("Day 8");
        let input = get_day_input(8)?;
        let (part1, part2) = day8::solve(&input, 1000);
        println!("{}", part1);
        println!(
            "{}",
            part2.map_or_else(|| "null".to_string(), |part2| part2.to_string())
        );
        println!();
    }

    if args.is_empty() || args.contains("9") {
        println!("Day 9");
        let input = get_day_input(9)?;
        println!("{}", day9::part1(&input));
        println!("{}", day9::part2(&input));
        println!();
    }

    if args.is_empty() || args.contains("11") {
        println!("Day 11");
        let input = get_day_input(11)?;
        println!("{}", day11::part1(&input));
        println!("{}", day11::part2(&input));
        println!();
    }

    Ok(())
}
