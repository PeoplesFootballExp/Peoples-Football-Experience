use godot::classes::{CharacterBody3D, ICharacterBody3D};
use godot::prelude::*;

struct PfeGame {}

#[gdextension]
unsafe impl ExtensionLibrary for PfeGame {}

#[derive(GodotClass)]
#[class(base = CharacterBody3D)]
pub struct Player {
    base: Base<CharacterBody3D>,
}

#[godot_api]
impl ICharacterBody3D for Player {
    fn init(base: Base<CharacterBody3D>) -> Self {
        Self { base }
    }

    fn process(&mut self, _delta: f64) {
        let pos = self.base().get_global_position();
        godot_print!("Player position: {pos}/tFrame Time: {_delta}")
    }
}
