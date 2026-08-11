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
pub struct TechnicalAbilities {
    pub passing: u8,
    pub crossing: u8,
    pub dribbling: u8,
    pub first_touch: u8,
    pub finishing: u8,
    pub power: u8,
    pub long_shots: u8,
    pub tackling: u8,
    pub marking: u8,
    pub heading: u8,
    pub technique: u8,
    pub free_kicks: u8,
    pub corners: u8,
    pub penalties: u8,
    pub long_throws: u8,
    pub skill_moves: u8,
}

#[derive(Component)]
pub struct MentalAbilities {
    pub anticipation: u8,
    pub positioning: u8,
    pub off_the_ball: u8,
    pub decisions: u8,
    pub composure: u8,
    pub concentration: u8,
    pub vision: u8,
    pub teamwork: u8,
    pub aggression: u8,
    pub determination: u8,
    pub flair: u8,
    pub work_rate: u8,
    pub bravery: u8,
    pub leadership: u8,
}

#[derive(Component)]
pub struct PhysicalAbilities {
    pub pace: u8,
    pub acceleration: u8,
    pub agility: u8,
    pub balance: u8,
    pub strength: u8,
    pub stamina: u8,
    pub jumping_reach: u8,
    pub natural_fitness: u8,
    pub height: u8,
    pub weight: u8,
    pub injury_proneness: u8,
    pub dominant_foot: bool,
    pub weak_foot: u8,
}

#[derive(Component)]
pub struct GoalkeepingAbilities {
    pub handling: u8,
    pub reflexes: u8,
    pub one_on_ones: u8,
    pub aerial_reach: u8,
    pub kicking: u8,
    pub throwing: u8,
    pub keeper_positioning: u8,
    pub command_of_area: u8,
    pub eccentricity: u8,
}

#[derive(Component)]
pub struct Personality {
    pub ambition: u8,
    pub professionalism: u8,
    pub loyalty: u8,
    pub pressure_handling: u8,
    pub temperament: u8,
    pub adaptability: u8,
    pub sportsmanship: u8,
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
