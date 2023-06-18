// Use the notify create to watch the filesystem for changes based on the first command line
// argument.

use std::{path::Path, time::Duration};

use notify::RecursiveMode;
use notify_debouncer_mini::new_debouncer;

fn main() {
    let args: Vec<String> = std::env::args().collect();
    if args.len() != 3 {
        println!("Usage: {} <path> <command>", args[0]);
        std::process::exit(1);
    }

    let path = args.get(1).unwrap();
    let cmd = args.get(2).unwrap();

    // setup debouncer
    let (tx, rx) = std::sync::mpsc::channel();

    // No specific tickrate, max debounce time 2 seconds
    let mut debouncer = new_debouncer(Duration::from_secs(1), None, tx).unwrap();

    debouncer
        .watcher()
        .watch(Path::new(&path), RecursiveMode::Recursive)
        .unwrap();

    // print all events, non returning
    for result in rx {
        match result {
            Ok(_) => {
                // execute the command:
                std::process::Command::new(cmd.clone())
                    .spawn()
                    .unwrap();
            },
            Err(error) => {
                println!("Error: {:?}", error);
            }
        }
    }
}
