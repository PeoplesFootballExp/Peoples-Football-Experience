use bevy_ecs::prelude::Component;


/// The component to track position of the entity in a 3D scene. Uses X,Y,Z fields
#[derive(Component)]
pub struct PositionComponent {
    pub x: f32,
    pub y: f32,
    pub z: f32,
}

/// The component to track velocities of an entity in a 3D scene. Uses X,Y,Z fields
#[derive(Component)]
pub struct VelocityComponent {
    pub x: f32,
    pub y: f32,
    pub z: f32,
}

/// The component to track the acceleration of an entity in a 3D scene. Uses X,Y,Z fields
#[derive(Component)]
pub struct AccelerationComponent {
    pub x: f32,
    pub y: f32,
    pub z: f32,
}