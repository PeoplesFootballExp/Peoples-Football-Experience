use bevy_ecs::prelude::*;


#[derive(Component)]
pub struct NameInfo {
    pub name: String,
    pub official_name: String,
    pub alt_name: String,
    pub code: String,
}