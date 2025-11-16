use std::fs;
use std::path::{Path, PathBuf};
use image::{DynamicImage, EncodableLayout};
use jxl_oxide::integration::JxlDecoder;
use webp::{Encoder, WebPConfig, WebPImage, WebPMemory}; // webp::WebPImage is WebPMemory
use rayon::prelude::*; 

// --- Custom Error and Task Result Definitions ---
#[derive(Debug)]
struct CustomError(String);

impl std::fmt::Display for CustomError {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        write!(f, "{}", self.0)
    }
}
impl std::error::Error for CustomError {}
unsafe impl Send for CustomError {}

type TaskResult = Result<(), Box<dyn std::error::Error + Send>>;

// Helper for converting string literals to boxed errors
fn custom_error(s: &str) -> Box<dyn std::error::Error + Send> { 
    Box::new(CustomError(s.to_string()))
}


// --- SHARED ENCODING LOGIC (WebP Lossy Q90) ---

/// Encodes a DynamicImage into a WebP file at 90% quality and saves it to disk.
fn encode_to_webp(image: DynamicImage, output_path: &Path) -> TaskResult {
    // 1. Create WebP Encoder from DynamicImage
    let image_webp = webp::Encoder::from_image(&image)
        .map_err(|e| custom_error(&format!("Failed to create WebP encoder: {}", e)))?;
    
    // 2. Encode to lossy WebP at 90.0 quality
    // Note: The webp crate's simple encoder uses (is_lossless, quality)
    let lossy_image: WebPMemory = image_webp.encode_simple(false, 100.0).unwrap();

    // 3. Save the encoded bytes to the file system
    std::fs::write(output_path, lossy_image.as_bytes())
        .map_err(|e| Box::new(e) as Box<dyn std::error::Error + Send>)?;
    
    println!("Saved: {}", output_path.display());
    Ok(())
}


/// Handles the decoding of one PNG file and saves it as a WebP file.
fn process_png_file(input_path: PathBuf, output_path: PathBuf) -> TaskResult {
    println!("Processing PNG: {}", input_path.file_name().unwrap_or_default().to_string_lossy());
    
    // 1. Ensure output directory exists
    let parent_dir = output_path.parent().ok_or_else(|| custom_error("Invalid output path directory"))?;
    fs::create_dir_all(parent_dir).map_err(|e| Box::new(e) as Box<dyn std::error::Error + Send>)?;

    // 2. DECODE (PNG)
    let image = image::open(&input_path)
        .map_err(|e| Box::new(e) as Box<dyn std::error::Error + Send>)?;

    // 3. Resize 
    let image_resized = image.resize(256, 256, image::imageops::FilterType::Lanczos3);

    encode_to_webp(image_resized, &output_path)
}


// --- JXL CONVERSION FUNCTION (RENAMED) ---

/// Handles the decoding of one JXL file and saves it as a WebP file.
fn process_jxl_file(input_path: PathBuf, output_path: PathBuf) -> TaskResult {
    println!("Processing JXL: {}", input_path.file_name().unwrap_or_default().to_string_lossy());
    
    // 1. Ensure output directory exists
    let parent_dir = output_path.parent().ok_or_else(|| custom_error("Invalid output path directory"))?;
    fs::create_dir_all(parent_dir).map_err(|e| Box::new(e) as Box<dyn std::error::Error + Send>)?;

    // 2. DECODE (JXL)
    let file = fs::File::open(&input_path).map_err(|e| Box::new(e) as Box<dyn std::error::Error + Send>)?;
    let decoder = JxlDecoder::new(file).map_err(|e| Box::new(e) as Box<dyn std::error::Error + Send>)?;
    let image = DynamicImage::from_decoder(decoder).map_err(|e| Box::new(e) as Box<dyn std::error::Error + Send>)?;
    
    // 3. ENCODE (WebP)
    encode_to_webp(image, &output_path)
}


/// Recursively collects all JXL and PNG file paths and converts them using parallel processing.
pub fn convert_assets_to_webp(
    root_path: &Path, 
    webp_root_path: &Path, 
    _quality: f32
) -> Result<(), Box<dyn std::error::Error + Send>> {
    
    // Tuple stores (Input Path, Output Path, Conversion Function Pointer)
    let mut task_data: Vec<(PathBuf, PathBuf, fn(PathBuf, PathBuf) -> TaskResult)> = Vec::new();
    
    fn collect_paths(
        current_dir: &Path, 
        root_dir: &Path, 
        out_root_dir: &Path, 
        task_data: &mut Vec<(PathBuf, PathBuf, fn(PathBuf, PathBuf) -> TaskResult)>
    ) -> TaskResult {
        
        let read_dir_iter = fs::read_dir(current_dir).map_err(|e| Box::new(e) as Box<dyn std::error::Error + Send>)?;

        for entry in read_dir_iter {
            let entry = entry.map_err(|e| Box::new(e) as Box<dyn std::error::Error + Send>)?;
            let input_path = entry.path();

            if input_path.is_dir() {
                collect_paths(&input_path, root_dir, out_root_dir, task_data)?;
            } else if let Some(ext) = input_path.extension().and_then(|s| s.to_str()).map(|s| s.to_lowercase()) {
                
                let conversion_fn: Option<fn(PathBuf, PathBuf) -> TaskResult> = match ext.as_str() {
                    "jxl" => Some(process_jxl_file),
                    "png" => Some(process_png_file), // NEW: Handler for PNG
                    _ => None,
                };
                
                if let Some(c_fn) = conversion_fn {
                    let relative_path = input_path.strip_prefix(root_dir).map_err(|e| Box::new(e) as Box<dyn std::error::Error + Send>)?;
                    let file_stem = input_path.file_stem().ok_or_else(|| {
                        custom_error("Invalid file name")
                    })?;
                    
                    let mut output_path = out_root_dir.join(relative_path.parent().unwrap_or(Path::new("")));
                    output_path.push(file_stem);
                    output_path.set_extension("webp");
                    
                    task_data.push((input_path, output_path, c_fn)); 
                }
            }
        }
        Ok(())
    }

    println!("Collecting file paths (JXL and PNG)...");
    collect_paths(root_path, root_path, webp_root_path, &mut task_data)?;
    println!("Found {} files. Starting parallel conversion...", task_data.len());
    
    // 2. Process tasks in parallel using Rayon
    let results: Vec<TaskResult> = task_data
        .into_par_iter() 
        .map(|(input_path, output_path, conversion_fn)| { 
            // Call the function pointer corresponding to the file type
            conversion_fn(input_path, output_path)
        })
        .collect();

    // 3. Report summary of errors
    let errors: Vec<_> = results.into_iter().filter_map(Result::err).collect();
    if !errors.is_empty() {
        eprintln!("\n--- Conversion Finished with {} Errors ---", errors.len());
    } else {
        println!("\nAll files processed successfully.");
    }

    Ok(())
}

fn main() {
    let source_path = Path::new(""); // Assuming this path now contains your PNG files too
    let webp_path = Path::new("");
    
    // Renamed function to reflect it now handles both types
    match convert_assets_to_webp(source_path, webp_path, 90.0) { 
        Ok(_) => {}, 
        Err(e) => eprintln!("\nFatal initialization error: {}", e),
    }
}
