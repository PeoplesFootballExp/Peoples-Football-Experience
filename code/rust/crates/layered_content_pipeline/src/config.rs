use enum_map::{Enum, EnumMap};
use godot::classes::FileAccess;
use godot::classes::file_access::ModeFlags;
use godot::prelude::*;
use serde::Deserialize;

const MANIFEST_PATH: &str = "res://assets/manifest.toml";

#[derive(Debug, Deserialize, Clone, Copy, Enum)]
pub enum AssetType {
    ClubLogo,
    ClubKit,
    PlayerPortrait,
    ManagerPortrait,
    StadiumModel,
    StadiumSponsorBoard,
    PitchTexture,
    AudioChant,
}

#[derive(Debug, Deserialize, Clone)]
pub struct PipelineLocations {
    pub base: String,
    pub mods: String,
    pub global: String,
    pub save: String,
}

#[derive(Debug, Clone)]
pub struct PipelineConfig {
    pub locations: PipelineLocations,
    pub formats: EnumMap<AssetType, String>,
    pub categories: EnumMap<AssetType, String>,
    pub fallback: EnumMap<AssetType, String>,
}

#[derive(Debug, Deserialize)]
pub struct ManifestConfig {
    pub locations: String,
    pub formats: String,
    pub categories: String,
    pub fallbacks: String,
}

impl ManifestConfig {
    pub fn load_manifest_via_godot() -> Result<ManifestConfig, String> {
        let gpath = GString::from(MANIFEST_PATH);

        if let Some(file) = FileAccess::open(&gpath, ModeFlags::READ) {
            let toml_content = file.get_as_text().to_string();
            ManifestConfig::from_toml(&toml_content).map_err(|e| format!("TOML Parse Error: {}", e))
        } else {
            let err_code = FileAccess::get_open_error();
            Err(format!(
                "Godot FileAccess failed to open '{}'. Error code: {:?}",
                MANIFEST_PATH, err_code
            ))
        }
    }

    pub fn from_toml(content: &str) -> Result<Self, toml::de::Error> {
        toml::from_str(content)
    }
}
