use bevy_ecs::prelude::Component;


/// The component to track position of the entity in a 3D scene. Uses X,Y,Z fields
#[derive(Component)]
pub struct PositionComponent {
    pub x: i32,
    pub y: i32,
    pub z: i32,
}

/// The component to track velocities of an entity in a 3D scene. Uses X,Y,Z fields
#[derive(Component)]
pub struct VelocityComponent {
    pub x: i32,
    pub y: i32,
    pub z: i32,
}

/// The component to track the acceleration of an entity in a 3D scene. Uses X,Y,Z fields
#[derive(Component)]
pub struct AccelerationComponent {
    pub x: i32,
    pub y: i32,
    pub z: i32,
}