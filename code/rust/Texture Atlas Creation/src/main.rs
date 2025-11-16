use image::{
    // Core image types
    GenericImage, ImageBuffer, Rgba,
    // Utilities for decoding and encoding
    ImageFormat, DynamicImage,
};
use std::path::{Path, PathBuf};
use std::fs;
use glob::glob;

// --- CONFIGURATION CONSTANTS ---
const ATLAS_SIZE: u32 = 4096; // The final 4K texture atlas dimension
const TILE_SIZE: u32 = 256;  // The dimension of each input image (e.g., 256x256)
const ATLAS_FILENAME: &str = "output_atlas.png";
const INPUT_DIR: &str = "";

/// Creates a new texture atlas by copying multiple same-sized images into a single, larger image.
///
/// This function assumes:
/// 1. All input images have the same dimensions (`TILE_SIZE` x `TILE_SIZE`).
/// 2. The total capacity of the atlas (`ATLAS_SIZE` x `ATLAS_SIZE`) is sufficient
///    to hold all input images.
/// 3. No padding is required between tiles.
///
/// # Arguments
/// - `input_image_paths` - A vector of paths to the source images.
///
/// # Returns
/// A `Result` indicating success or an error string.
fn create_texture_atlas(input_image_paths: Vec<PathBuf>) -> Result<(), String> {
    // 1. Calculate grid dimensions
    let tiles_per_row = ATLAS_SIZE / TILE_SIZE;
    let max_tiles = tiles_per_row * tiles_per_row;

    // Check if the atlas is large enough for the images provided
    if input_image_paths.len() as u32 > max_tiles {
        return Err(format!(
            "Too many images! The 4K atlas ({}) can only hold {} tiles of size {}x{}. Found {} images.",
            ATLAS_SIZE, max_tiles, TILE_SIZE, TILE_SIZE, input_image_paths.len()
        ));
    }

    // 2. Create the destination image buffer (4096x4096 RGBA, initialized to black/transparent)
    // We use RGBA (Red, Green, Blue, Alpha) for full compatibility with common texture formats.
    let mut atlas: ImageBuffer<Rgba<u8>, Vec<u8>> = ImageBuffer::new(ATLAS_SIZE, ATLAS_SIZE);
    println!("Created a new atlas of {}x{} pixels.", ATLAS_SIZE, ATLAS_SIZE);

    // 3. Iterate through input images and place them on the atlas
    for (index, path) in input_image_paths.iter().enumerate() {
        let tile_index = index as u32;

        // Calculate the grid position (row and column)
        let col = tile_index % tiles_per_row;
        let row = tile_index / tiles_per_row;

        // Calculate the top-left pixel coordinates for the placement in the atlas
        let x_offset = col * TILE_SIZE;
        let y_offset = row * TILE_SIZE;

        // Load the source image
        let img = match image::open(path) {
            Ok(img) => img.into_rgba8(),
            Err(e) => {
                eprintln!("Error loading image {}: {}", path.display(), e);
                continue; // Skip this image and continue with the next
            }
        };

        // Validate the size of the loaded image
        // if TILE_SIZE >= std::cmp::max(img.width(), img.height()) {
        //     eprintln!(
        //         "Skipping image {}: Incorrect size. Expected {}x{}, got {}x{}",
        //         path.display(), TILE_SIZE, TILE_SIZE, img.width(), img.height()
        //     );
        //     continue;
        // }

        // Copy the pixels from the source image to the destination atlas
        // This is the most efficient way to copy in the image crate.
        match atlas.copy_from(&img, x_offset, y_offset) {
            Ok(_) => println!(
                "Copied tile {} to atlas at position ({}, {}), representing grid [{}, {}]",
                tile_index, x_offset, y_offset, col, row
            ),
            Err(e) => {
                // This error should only happen if the copy goes outside the bounds of the atlas,
                // which our math above prevents.
                return Err(format!(
                    "Failed to copy image {} into atlas: {}", path.display(), e
                ));
            }
        }
    }

    // 4. Save the resulting atlas image
    match atlas.save_with_format(ATLAS_FILENAME, ImageFormat::Png) {
        Ok(_) => {
            println!("\nSUCCESS: Texture Atlas saved to '{}'", ATLAS_FILENAME);
            Ok(())
        },
        Err(e) => Err(format!("Failed to save atlas: {}", e)),
    }
}

/// Helper function to create dummy 256x256 PNG images for testing.
fn create_dummy_image(path: &Path, color: Rgba<u8>, text: &str) -> Result<(), image::ImageError> {
    let mut img: ImageBuffer<Rgba<u8>, Vec<u8>> = ImageBuffer::from_pixel(TILE_SIZE, TILE_SIZE, color);

    // To add simple text, we'd need another crate (like rusttype/ab_glyph),
    // but for simplicity, we'll just draw a colored square with a distinct center.
    // Draw a small white/black square in the center to make them visually distinct
    let center_color = if color[0] > 128 { Rgba([0, 0, 0, 255]) } else { Rgba([255, 255, 255, 255]) };
    let half_size = TILE_SIZE / 2;
    let quarter_size = TILE_SIZE / 4;

    for y in half_size - 16..half_size + 16 {
        for x in half_size - 16..half_size + 16 {
            if x < TILE_SIZE && y < TILE_SIZE {
                img.put_pixel(x, y, center_color);
            }
        }
    }

    img.save(path)
}

fn main() {
    println!("--- Texture Atlas Generator (Rust) ---");
    println!("Tile Size: {}x{}", TILE_SIZE, TILE_SIZE);
    println!("Atlas Size: {}x{}", ATLAS_SIZE, ATLAS_SIZE);
    println!("Tiles per row: {}\n", ATLAS_SIZE / TILE_SIZE);

    // --- CORE LOGIC: Find all images and build the atlas ---

    // 1. Collect all image file paths from the input directory
    let pattern = format!("{}/*.png", INPUT_DIR);
    let image_paths: Vec<PathBuf> = match glob(&pattern) {
        Ok(paths) => paths
            .filter_map(Result::ok)
            .collect(),
        Err(e) => {
            eprintln!("Error reading file paths: {}", e);
            return;
        }
    };

    if image_paths.is_empty() {
        println!("No PNG images found in '{}'. Exiting.", INPUT_DIR);
        return;
    }

    // 2. Run the main atlas creation function
    match create_texture_atlas(image_paths) {
        Ok(_) => println!("Atlas generation complete."),
        Err(e) => eprintln!("Atlas generation failed: {}", e),
    }

}