use std::io::Write;

fn main() {
    let mut input = String::new();

    println!("What is your name?");
    std::io::stdout().flush().unwrap();
    std::io::stdin().read_line(&mut input).unwrap();
    println!("Hello {}!", input.trim());
}
