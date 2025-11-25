use bevy_ecs::prelude::Component;

#[derive(Component)]
pub struct ImageAsset {
    // The path to the image used for the entity. These images can range from flags, logos, to even
    // player pictures. 
    pub image_path: String,

    // The dimensions of the image, internal fields not meant to be saved to the database but useful
    // for quickly adjusting aspect ratio of nodes in Godot
    pub _width: u32,
    pub _height: u32,
}

