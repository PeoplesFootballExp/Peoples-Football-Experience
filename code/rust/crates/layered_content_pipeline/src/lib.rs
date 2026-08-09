use crate::config::ManifestConfig;

pub mod config;

pub fn add(left: u64, right: u64) -> u64 {
    left + right
}

pub fn print_manifest() {
    if let Ok(manifest) = ManifestConfig::load_manifest_via_godot() {
        println!("{:#?}", manifest);
    } else {
        eprintln!("Failed to load manifest");
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = add(2, 2);
        assert_eq!(result, 4);
    }
}
