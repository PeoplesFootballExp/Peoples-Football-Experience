use bevy_ecs::prelude::*;


#[derive(Component)]
pub struct NamesComponent {
    // The commonly used name for the entity. For example, a nickname used by a famous football player
    pub name: String,
    // The official name of an entity. Typically less commonly used or longer than the commonly used name
    pub official_name: String,
    // An optional third name for an entity. Commonly used for territories 
    pub alt_name: Option<String>,
    // The unique, short code (e.g., "MUN")
    pub code: Option<String>,
    // The optional demonym for the entity especially if it is a territory
    pub demonym: Option<String>
}

/// This component serves as a tag to show when something is in a hierarchal tree (e.g league pyramid,
/// confederation tree, territory tree, etc). Allows for quick querying of all entities at a certain level
/// without tranversing the tree
#[derive(Component)]
pub struct LevelComponent {
    // The level the hierarchal entity is in the parent/child tree
    pub level: u8,
}

/// This component serves to assign a gender to the entity, useful for tournaments, players, etc
#[derive(Component)]
pub struct GenderComponent {
    // The Gender of the entity, a simple bool where false is Mens and True is Womens
    pub gender: bool,
}

/// This component serves to assign a team type to the entity, useful for tournaments, players, etc
#[derive(Component)]
pub struct TeamTypeComponent {
    // The team type of the entity, a simple bool where False is National Teams and True is Clubs
    pub team_type: bool,
}

/// This component saves 3 main colors for an entity
#[derive(Component)]
pub struct ColorsComponent {
    // Packed A R G B (Alpha, Red, Green, Blue) into one integer.
    // Example: 0xFF00FF00 (Full Alpha, Full Green)
    pub primary_color: u32,
    // secondary color, also a packed u32
    pub secondary_color: Option<u32>,
    // Teritary Color, also packed u32
    pub tertiary_color: Option<u32>, 
}

/// The Birthday of the entity 
#[derive(Component)]
pub struct BirthdayComponent {
    // The Year, mandatory value
    pub year: u32,
    // The Month, optional value
    pub month: Option<u8>,
    // The Day, optional value
    pub day: Option<u8>,
}

// The Priorities of the Team Entity. These are measured
// in ranges of 1 to 5
#[derive(Component)]
pub struct TeamPrioritiesComponent {
    // The priority of the ensuring youth academies
    // being good and producing youth prospects
    pub youth_development: u8,
    // Financial Stability is ensuring the team does not
    // build up a lot of debt and is able to pay all expenses
    pub financial_stability: u8,
    // Reputation and Branding decide how much the team wants
    // to ensure a positive branding image across the country
    // and world. Useful for attracting better players and deals
    pub reputation_branding: u8,
    // Facility Maintenance is how important it is to improve stadium
    // conditions and ensure staff are happy and stable
    pub facility_maintenance: u8,
    // Domestic Success is how important winning local tournaments are
    pub domestic_success: u8,
    // International Success is how important winning international tournaments
    // are for the team
    pub international_success: u8,
    // Continental Success is how important winning continental
    // tournaments are for the team
    pub continental_success: u8, 
}

