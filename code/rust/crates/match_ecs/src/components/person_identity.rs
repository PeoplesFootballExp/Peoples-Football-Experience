#[derive(Component)]
pub struct PlayerId {
    pub id: u32,
}

#[derive(Component)]
pub struct EntityId {
    pub id: u32,
}

#[derive(Component)]
pub struct PersonName {
    pub given_primary: u32,
    pub given_secondary: u32,
    pub family_primary: u32,
    pub family_secondary: u32,
    pub mononym: u32,
    pub nickname: u32,
}

#[derive(Component)]
pub struct PersonAge {
    pub birth_day: u8,
    pub birth_month: u8,
    pub birth_year: u32,
    pub age: u8,
}

#[derive(Component)]
pub struct PersonBirthPlace {
    pub city: u32,
    pub state: u32,
    pub country: u32,
}

#[derive(Component)]
pub struct MatchAttributes {
    pub current_stamina: u8,
    pub current_max_stamina: u8,
    pub current_position: u8,
    pub current_role: u8,
}

pub enum MatchSide {
    Home,
    Away,
}

#[derive(Component)]
pub struct PlayerTeam {
    pub side: MatchSide,
}
