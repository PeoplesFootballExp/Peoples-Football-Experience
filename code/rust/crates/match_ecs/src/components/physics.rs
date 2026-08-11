#[derive(Component)]
pub struct Position {
    pub x: f32,
    pub y: f32,
    pub z: f32,
}

#[derive(Component)]
pub struct Velocity {
    pub x: f32,
    pub y: f32,
    pub z: f32,
}

#[derive(Component)]
pub struct Acceleration {
    pub x: f32,
    pub y: f32,
    pub z: f32,
}

#[derive(Component)]
pub struct Kinematics {
    pub facing_angle_rad: f32,
    pub movement_angle_rad: f32,
}

#[derive(Component)]
pub struct MatchCondition {
    pub current_stamina: f32,

    pub sprint_energy: f32,

    pub accumulated_fatigue: f32,
    // Minor match knock (e.g. limping after a heavy tackle, temporarily drops top )
    pub transient_knock_severity: f32,
}

#[derive(Component)]
pub struct BallInteractionState {
    pub is_in_possession: bool,
    pub touch_distance: f32,
    pub action_phase: u8,
    pub touch_cooldown_ticks: u8,
}
