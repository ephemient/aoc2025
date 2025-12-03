pub fn solve(input: &str) -> (u32, u32) {
    let (mut pos, mut zeros, mut turns) = (50, 0, 0);
    for line in input.lines() {
        let rotation = if let Some(line) = line.strip_prefix('L') {
            -line.parse::<i32>().unwrap()
        } else if let Some(line) = line.strip_prefix('R') {
            line.parse().unwrap()
        } else {
            continue;
        };
        let pos2 = pos + rotation;
        turns += pos2.abs_diff(rotation.signum()) / 100 + (pos != 0 && pos2 < 0) as u32;
        pos = pos2.rem_euclid(100);
        zeros += (pos == 0) as u32;
    }
    (zeros, zeros + turns)
}
