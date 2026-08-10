use enum_map::{Enum, EnumMap};
use rustc_hash::FxHashMap;
use serde::{Deserialize, Deserializer};
use std::collections::HashMap;
use uuid::Uuid;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Deserialize, Enum)]
pub enum AssetType {
    TeamLogo,
    TeamKitHome,
    TeamKitAway,
    TeamKitThird,
    TeamKitGoalKeeper,
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

#[derive(Hash, Eq, PartialEq, Debug, Clone)]
pub struct EntityAssetKey {}
