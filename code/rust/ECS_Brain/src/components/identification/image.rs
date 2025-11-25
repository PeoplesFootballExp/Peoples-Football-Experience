use bevy_ecs::prelude::Component;

#[derive(Component)]
pub struct ImageAsset {
    pub image_path: String,
    pub width: u32,
    pub height: u32,
}

