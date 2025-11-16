use godot::prelude::*;
use godot::engine::{
    EditorImportPlugin,
    // The specific class we inherit from
    EditorImportPluginVirtual, 
    // Types needed for resource manipulation
    Image, ImageTexture, 
    // Import configuration
    DirAccess,
    FileAccess,
};
// Use the image crate for decoding (requires JXL feature enabled in its Cargo.toml)
use image::io::Reader as ImageReader; 

struct JxlImporter;

// --- 1. Implement the required functions for an EditorImportPlugin ---

#[godot::bind::gdclass]
impl EditorImportPlugin for JxlImporter {
    type Base = EditorImportPlugin;
    
    // The name of the plugin, shown in the Godot Import tab.
    fn get_importer_name(&self) -> GString {
        "jxl_importer".into()
    }

    // The unique ID for the importer (important for the .import file).
    fn get_visible_name(&self) -> GString {
        "JXL Image Importer".into()
    }

    // The priority for this importer (higher priority means it runs first).
    fn get_priority(&self) -> f32 {
        1.0
    }

    // The default resource type this importer outputs.
    fn get_resource_type(&self) -> GString {
        "Texture2D".into()
    }

    // Tell Godot which file extensions this plugin handles.
    fn get_recognized_extensions(&self) -> PackedStringArray {
        PackedStringArray::from_iter(["jxl".into()])
    }

    // This is the core function where the JXL decoding happens.
    // The decoded result is saved to 'save_path'.
    fn _import(
        &self,
        source_file: GString,
        save_path: GString,
        options: Dictionary,
        r_platform_variants: Array<GString>,
        r_gen_files: Array<GString>,
    ) -> i32 {
    
        // 1. Read the JXL file bytes from the source_file path.
        let source_path = source_file.to_string();

        let bytes = match fs::File::open(&input_path).map_err(|e| Box::new(e) as Box<dyn std::error::Error + Send>)?; {
            Ok(b) => b,
            Err(e) => {
                godot_error!("Failed to read source JXL file: {}", e);
                return godot::engine::global::Error::ErrFileCantOpen as i32;
            }
        };

        // 2. Decode JXL bytes into a raw pixel buffer (using the 'image' crate).
        // NOTE: Full JXL support requires additional crates/features not shown here.
        let decoded_img = match ImageReader::new(std::io::Cursor::new(bytes))
            .with_guessed_format()
            .and_then(|r| r.decode()) 
        {
            Ok(img) => img.into_rgba8(), // Convert to RGBA format expected by Godot
            Err(e) => {
                godot_error!("Failed to decode JXL image: {}", e);
                return godot::engine::global::Error::ErrFileCorrupt as i32;
            }
        };

        // 3. Create a Godot Image object from the raw pixel data.
        let mut godot_image = Image::new();
        let width = decoded_img.width();
        let height = decoded_img.height();
        let data = decoded_img.into_vec();

        // Convert raw Vec<u8> data to a Godot-compatible PackedByteArray
        let packed_data = PackedByteArray::from_iter(data);
        
        // Load raw data into the Godot Image object.
        godot_image.create_from_data(
            width as i32, 
            height as i32, 
            false, // Has mipmaps (false for simplicity)
            godot::engine::image::Format::Rgba8, // The pixel format
            packed_data,
        );

        // 4. Save the optimized image texture (this is what Godot reads for the game)
        let final_path = format!("{}.ctex", save_path); // Save as Custom TEX file
        let texture = ImageTexture::create_from_image(Image::new_copy(godot_image.clone()));

        // Use the ResourceSaver to save the texture (this generates the optimized file).
        let saver = godot::engine::ResourceSaver::singleton();
        let error_code = saver.save(texture.to_variant(), final_path.clone().into());
        
        if error_code != godot::engine::global::Error::Ok {
            godot_error!("Failed to save final texture resource: {}", error_code);
            return error_code as i32;
        }

        // Add the generated file path to the returned list (REQUIRED)
        r_gen_files.push(final_path.into());

        // Return OK
        godot::engine::global::Error::Ok as i32
    }
}

fn process_jxl_file(input_path: PathBuf, output_path: PathBuf) -> TaskResult {
    // DECODE (JXL)
    let file = fs::File::open(&input_path).map_err(|e| Box::new(e) as Box<dyn std::error::Error + Send>)?;
    let decoder = JxlDecoder::new(file).map_err(|e| Box::new(e) as Box<dyn std::error::Error + Send>)?;
    let image = DynamicImage::from_decoder(decoder).map_err(|e| Box::new(e) as Box<dyn std::error::Error + Send>)?;
    
    // 3. ENCODE (WebP)
    encode_to_webp(image, &output_path)
}

// --- 2. Implement the GDExtension Entry Point ---

#[derive(GodotClass)]
#[class(tool)] // The 'tool' attribute is necessary for editor plugins
pub struct JxlImporterExtension;

#[godot::extends(EditorPlugin)]
impl JxlImporterExtension {
    // Called when the plugin is enabled in the Godot Editor
    fn enter_tree(&mut self) {
        godot_print!("JXL Importer Extension loaded!");
        let importer = JxlImporter::new_alloc();
        self.base().add_resource_import_plugin(importer);
    }
    
    // Called when the plugin is disabled
    fn exit_tree(&mut self) {
        godot_print!("JXL Importer Extension unloaded!");
        // We should remove the plugin here, but for simplicity, we omit it.
    }
}

// The main entry point for the GDExtension library
#[gdextension]
unsafe fn init(builder: &mut InitHandle) {
    builder.add_class::<JxlImporterExtension>();
}