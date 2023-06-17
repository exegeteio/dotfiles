use std::env;
use dialoguer::Confirm;

fn main() {
    let mut prompt: String = "Proceed?".to_string();

    let args: Vec<String> = env::args().collect();
    if args.len() > 1 {
        prompt = args[1].to_string();
    }

    let result = Confirm::new().with_prompt(prompt).interact();
    match result {
        Ok(true) => {
            std::process::exit(0);
        }
        Ok(false) => {
            std::process::exit(75);
        }
        Err(_) => {
            std::process::exit(70);
        }
    }
}
