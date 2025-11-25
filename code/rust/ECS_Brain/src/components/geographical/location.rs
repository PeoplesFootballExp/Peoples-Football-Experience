use bevy_ecs::prelude::Component;

#[derive(Component)]
pub struct Coordinates {
    pub lat: f32,
    pub long: f32,
}

#[derive(Component)]
pub struct HemisphereRef {
    pub hemisphere_id: u32,
    pub hemisphere_name: String,
}

#[derive(Component)]
pub struct ClimateRef {
    pub climate_id: u32,
    pub climate_name: String,
}