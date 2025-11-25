use bevy_ecs::prelude::Component;

/// The Unique ID for all entities of type Player. For an entity to be of type Player,
/// it must have this component present. In essence, this component serves to both tag
/// entities as a Player entity but also serves to store a unique ID that can be persisted 
/// in an external database
#[derive(Component)]
pub struct PlayerIDComponent {
    pub id: u32,
}

/// The Unique ID for all entities of type Territory. For an entity to be of type Territory,
/// it must have this component present. In essence, this component serves to both tag
/// entities as a Territory entity but also serves to store a unique ID that can be persisted 
/// in an external database
#[derive(Component)]
pub struct TerritoryIDComponent {
    pub id: u32,
}

/// The Unique ID for all entities of type Confederation. For an entity to be of type Confederation,
/// it must have this component present. In essence, this component serves to both tag
/// entities as a Confederation entity but also serves to store a unique ID that can be persisted 
/// in an external database
#[derive(Component)]
pub struct ConfederationIDComponent {
    pub id: u32,
}

/// The Unique ID for all entities of type City. For an entity to be of type City,
/// it must have this component present. In essence, this component serves to both tag
/// entities as a City entity but also serves to store a unique ID that can be persisted 
/// in an external database
#[derive(Component)]
pub struct CityIDComponent {
    pub id: u32,
}

/// The Unique ID for all entities of type Manager. For an entity to be of type Manager,
/// it must have this component present. In essence, this component serves to both tag
/// entities as a Manager entity but also serves to store a unique ID that can be persisted 
/// in an external database
#[derive(Component)]
pub struct ManagerIDComponent {
    pub id: u32,
}

/// The Unique ID for all entities of type Stadium. For an entity to be of type Stadium,
/// it must have this component present. In essence, this component serves to both tag
/// entities as a Stadium entity but also serves to store a unique ID that can be persisted 
/// in an external database
#[derive(Component)]
pub struct StadiumIDComponent {
    pub id: u32,
}

