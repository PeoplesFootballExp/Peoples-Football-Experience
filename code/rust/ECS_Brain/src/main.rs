
pub mod components;
use bevy_ecs::prelude::*;
use bevy_ecs::prelude::Entity;
use bevy_ecs::{component::Component, world::World};

use crate::components::three_dimensional::movement::Position;


fn main() {
    setup_world();
    
}

fn setup_world() {
    let mut world: World = World::new();
    let new_entity = world.spawn(Position{ x: 0, y: 0, z: 0}).id();

    println!("{}", world.get::<Position>(new_entity).unwrap().x.to_string());

}
