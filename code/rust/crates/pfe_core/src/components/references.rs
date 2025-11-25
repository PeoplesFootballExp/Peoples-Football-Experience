use bevy_ecs::prelude::Component;


/// ID pointer (aka a reference) to a PlayerID
#[derive(Component)]
pub struct TerritoryRefComponent {
    // Holds a reference to a territory that enables any entity to 
    // belong to a territory. This component will be using the Territory
    // unique ID component NOT the internal entitiy ID in the ECS. This is
    // to maintain persistent in an external database
    pub id: u32,
}

/// ID pointer (aka a reference) to a ConfederationID
#[derive(Component)]
pub struct ConfederationRefComponent {
    // Holds a reference to a Confederation that enables any entity to 
    // belong to a Confederation. This component will be using the Confederation
    // unique ID component NOT the internal entitiy ID in the ECS. This is
    // to maintain persistent in an external database
    pub id: u32,
}

/// ID pointer (aka a reference) to a TeamID
#[derive(Component)]
pub struct TeamRefComponent {
    // Holds a reference to a Team that enables any entity to 
    // belong to a Team. This component will be using the Team
    // unique ID component NOT the internal entitiy ID in the ECS. This is
    // to maintain persistent in an external database
    pub id: u32,
}

/// ID pointer (aka a reference) to a TeamID, this one specifically for a
/// rival team
#[derive(Component)]
pub struct RivalTeamRefComponent {
    // Holds a reference to a Team that enables any entity to 
    // have a main rival Team. This component will be using the Team
    // unique ID component NOT the internal entitiy ID in the ECS. This is
    // to maintain persistent in an external database
    pub id: u32,
}

/// ID pointer (aka a reference) to a CityID
#[derive(Component)]
pub struct CityRefComponent {
    // Holds a reference to a City that enables any entity to 
    // belong to a City. This component will be using the City
    // unique ID component NOT the internal entitiy ID in the ECS. This is
    // to maintain persistent in an external database
    pub id: u32,
}

/// ID pointer (aka a reference) to a StadiumID
#[derive(Component)]
pub struct StadiumRefComponent {
    // Holds a reference to a Stadium that enables any entity to 
    // belong to a Stadium. This component will be using the Stadium
    // unique ID component NOT the internal entitiy ID in the ECS. This is
    // to maintain persistent in an external database
    pub id: u32,
}








