use bevy_ecs::prelude::*;
use godot::prelude::*;

#[derive(GodotClass)]
#[class(base = Node)]
pub struct MatchSimulation {
    pub world: World,
    pub schedule: Schedule,
    base: Base<Node>,
}

#[godot_api]
impl INode for MatchSimulation {
    fn init(base: Base<Node>) -> Self {
        let mut world = World::new();
        let mut schedule = Schedule::default();

        Self {
            world,
            schedule,
            base,
        }
    }

    fn physics_process(&mut self, _delta: f64) {
        self.schedule.run(&mut self.world);
    }
}
