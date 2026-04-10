use bevy_ecs::prelude::Component;

#[derive(Component)]
pub struct ImageComponent {
    // The path to the image used for the entity. These images can range from flags, logos, to even
    // player pictures. 
    pub image_path: String,
}

pub struct ThreeDimComponent {
    pub three_d_model: String,
}



