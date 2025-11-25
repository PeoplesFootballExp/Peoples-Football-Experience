
pub mod components;
use bevy_ecs::prelude::*;
use bevy_ecs::prelude::Entity;
use bevy_ecs::{component::Component, world::World};

use crate::components::three_dimensional::movement::PositionComponent;


fn main() {
    setup_world();
    
}

fn setup_world() {
    let mut world: World = World::new();
    let e1 = world.spawn(PositionComponent{ x: 0, y: 0, z: 0}).id();
    let e2 = world.spawn(ChildOf(e1)).id();

    println!("{}", world.get::<PositionComponent>(e1).unwrap().x.to_string());
    



    

}
