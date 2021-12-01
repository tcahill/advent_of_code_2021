use std::fs::File;
use std::io::{BufRead, BufReader};

fn main() {
    let f = File::open("input").expect("Unable to open file");
    let buf = BufReader::new(f);

    let mut increasing_depth_count = 0;
    let mut window = Vec::new();
    let mut previous_window_reading: Option<i32> = None;

    for line in buf.lines() {
        let line = line.expect("Unable to read line");
        let depth = line.parse::<i32>().unwrap();
        window.push(depth);

        if window.len() < 3 {
            continue;
        }

        let window_reading: i32 = window.iter().sum();
        if previous_window_reading.is_some() && previous_window_reading.unwrap() < window_reading {
            increasing_depth_count += 1;
        }
        previous_window_reading = Some(window_reading);
        window.remove(0);
    }
    println!("{}", increasing_depth_count);
}
