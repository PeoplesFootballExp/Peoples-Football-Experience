import os
import subprocess
from PIL import Image

# --- Configuration ---
SOURCE_DIR = "G:/My Drive/Assets/2D Assets/Game 2D Assets/Testing/Confederation Logos/" # <<< CHANGE THIS to your main image folder
TARGET_SIZE = (256, 256)     # The desired WxH for logos
OUTPUT_DIR = "C:/Rust/2D Asset JXL 90 Quality/Confederation Logos/"    # All processed JXL files go here
CJXL_QUALITY = "90"             # "0" = Lossless. Use "90" for high-quality lossy.
CJXL_EFFORT = "10"
SUPPORTED_EXTENSIONS = ('.png', '.webp', '.jpg', '.jpeg')

def process_and_convert_to_jxl(input_path, output_jxl_path):
    """
    Performs the 3-step process: Load/32-bit conversion, Resize, and JXL Encoding.
    This function now takes the final output path directly.
    """
    # Use the filename for temporary files
    base_name = os.path.basename(input_path)
    temp_png_path = os.path.join(os.path.dirname(output_jxl_path), f"temp_{os.getpid()}_{base_name}.png")

    print(f"[{base_name}] Processing...")
    
    try:
        # Ensure the output directory for this specific file exists
        os.makedirs(os.path.dirname(output_jxl_path), exist_ok=True)
        
        # 1. Image Processing with Pillow
        img = Image.open(input_path)
        img.thumbnail(TARGET_SIZE, Image.Resampling.LANCZOS)  
        img_rgba8 = img.convert("RGBA")
        
        # 2. Save to temporary PNG file
        img_rgba8.save(temp_png_path)
        
        # 3. Execute cjxl conversion
        command = [
            "./cjxl", 
            temp_png_path, 
            output_jxl_path, 
            "-q", CJXL_QUALITY, 
            "-e", CJXL_EFFORT,
        ]
        
        subprocess.run(command, check=True, capture_output=True, text=True)
        
        print(f"[{base_name}] SUCCESS. Saved to {output_jxl_path}")

    except subprocess.CalledProcessError as e:
        print(f"[{base_name}] ERROR: cjxl failed. Details: {e.stderr.strip()}")
    except FileNotFoundError:
        print(f"[{base_name}] ERROR: 'cjxl' command not found. Ensure libjxl is installed and in your PATH.")
    except Exception as e:
        print(f"[{base_name}] UNEXPECTED ERROR during processing: {e}")
    finally:
        # Cleanup the temporary file
        if os.path.exists(temp_png_path):
            os.remove(temp_png_path)


def recursive_image_conversion(source_dir, output_dir):
    """
    Recursively explores the source directory, maintains structure, and calls the conversion function.
    """
    if not os.path.exists(source_dir):
        print(f"Source directory not found: {source_dir}. Exiting.")
        return
        
    print(f"--- Starting JXL Asset Generation ---")
    print(f"Source: {source_dir}\nOutput Root: {output_dir}\nTarget Size: {TARGET_SIZE}")
    print("---------------------------------------")

    # 1. Collect all paths for parallel processing
    all_tasks = []
    
    # Ensure SOURCE_DIR ends with a separator for correct relative path calculation
    # e.g., converts './source_images' to './source_images/'
    source_dir_path = os.path.abspath(source_dir)
    if not source_dir_path.endswith(os.sep):
        source_dir_path += os.sep

    for root, _, files in os.walk(source_dir):
        for file in files:
            if file.lower().endswith(SUPPORTED_EXTENSIONS):
                input_path = os.path.join(root, file)
                
                # --- KEY CHANGE: Calculate the relative path and new output path ---
                # Get the part of the path *after* the source directory (e.g., 'subfolder/logo.png')
                relative_path = os.path.relpath(input_path, source_dir)
                
                # Replace the original extension with .jxl
                relative_jxl_path = os.path.splitext(relative_path)[0] + ".jxl"
                
                # Create the final output path in the new structure
                output_jxl_path = os.path.join(output_dir, relative_jxl_path)
                
                all_tasks.append((input_path, output_jxl_path))

    print(f"Found {len(all_tasks)} images. Processing in parallel...")
    
    # 2. Use Process Pool Executor for parallel execution
    max_workers = os.cpu_count()
    with concurrent.futures.ProcessPoolExecutor(max_workers=max_workers) as executor:
        # The executor is configured to run the process_and_convert_to_jxl function
        # with the collected (input_path, output_jxl_path) tuples.
        futures = [executor.submit(process_and_convert_to_jxl, ip, op) for ip, op in all_tasks]
        
        # Monitor progress
        for future in concurrent.futures.as_completed(futures):
            try:
                future.result()
            except Exception as exc:
                print(f'Task generated an exception: {exc}')

    print("--- Processing Complete ---")


# --- Execution ---
if __name__ == "__main__":
    import concurrent.futures # Needs to be here if not top-level
    recursive_image_conversion(SOURCE_DIR, OUTPUT_DIR)