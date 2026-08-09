pub fn add(left: u64, right: u64) -> u64 {
    left + right
}

pub fn print_name() {
    println!("Hello, Its Eduardo");
}

// pub mod localization;

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = add(2, 2);
        assert_eq!(result, 4);
    }
}
