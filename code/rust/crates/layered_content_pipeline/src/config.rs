use enum_map::{Enum, EnumMap};
use rustc_hash::FxHashMap;
use serde::{Deserialize, Deserializer};
use std::collections::HashMap;
use uuid::Uuid;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Deserialize, Enum)]
pub enum AssetType {
    TeamLogo,
    TeamKit,
    TeamChant,
    TerritoryFlag,
    PersonPortrait,
    StadiumModel,
    TournamentScoreboard,
    PersonHead,
    PersonArm,
    PersonLeg,
    PersonFacialHair,
    PersonHair,
    PersonShirt,
    PersonPant,
    PersonShoe,
    PersonGlove,
}

#[derive(Debug, Deserialize, Clone)]
pub struct PipelineLocations {
    #[serde(rename = "Base")]
    pub base: String,
    #[serde(rename = "Mod")]
    pub mods: String,
    #[serde(rename = "Global")]
    pub global: String,
    #[serde(rename = "Save")]
    pub save: String,
}

#[derive(Debug, Deserialize, Clone)]
pub struct PipelineConfig {
    pub locations: PipelineLocations,
    pub formats: EnumMap<AssetType, String>,
    pub categories: EnumMap<AssetType, String>,
    pub fallback: EnumMap<AssetType, String>,

    // Convert string keys to u128 on-the-fly during Serde parsin
    #[serde(deserialize_with = "deserialize_uuid_assets")]
    pub assets: FxHashMap<u128, String>,
}

/// Custom deserializer that parses string UUID keys directly into u128 FxHashMap
fn deserialize_uuid_assets<'de, D>(deserializer: D) -> Result<FxHashMap<u128, String>, D::Error>
where
    D: Deserializer<'de>,
{
    let raw_map = HashMap::<String, String>::deserialize(deserializer)?;
    let mut assets = FxHashMap::with_capacity_and_hasher(raw_map.len(), Default::default());

    for (key, val) in raw_map {
        let uuid = Uuid::parse_str(&key).map_err(serde::de::Error::custom)?;
        assets.insert(uuid.as_u128(), val);
    }

    Ok(assets)
}

impl PipelineConfig {
    /// Deserializes TOML directly in a single pass
    pub fn from_toml(toml_str: &str) -> Result<Self, toml::de::Error> {
        toml::from_str(toml_str)
    }
}
