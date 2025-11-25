use bevy_ecs::prelude::Component;

#[derive(Component)]
pub struct Position {
    pub x: i32,
    pub y: i32,
    pub z: i32,
}

#[derive(Component)]
pub struct Velocity {
    pub x: i32,
    pub y: i32,
    pub z: i32,
}

#[derive(Component)]
pub struct Acceleration {
    pub x: i32,
    pub y: i32,
    pub z: i32,
}