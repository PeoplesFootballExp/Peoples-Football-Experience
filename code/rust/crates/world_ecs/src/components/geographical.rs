use bevy_ecs::prelude::Component;

#[derive(Component)]
pub struct CoordinateComponent {
    pub latitude: f32,
    pub longitude: f32,
}

#[derive(Component)]
pub struct HemisphereAttComponent {
    // Summar Start Month
    pub summer_start_month: u8,
    // Summar Start Day
    pub summer_start_day: u8,
    // Summar End Month
    pub summer_end_month: u8,
    // Summar End Day
    pub summer_end_day: u8,
    // Winter Start Month
    pub winter_start_month: u8,
    // Winter Start Day
    pub winter_start_day: u8,
    // Winter End Month
    pub winter_end_month: u8,
    // Winter End Day
    pub winter_end_day: u8,
}

#[derive(Component)]
pub struct ClimateAttComponent {
    // The chance of rain during the summer
    pub summer_rain_chance: u8,
    // The chance of snow during the summer
    pub summer_snow_chance: u8,
    // The chance of fog during the summer
    pub summer_fog_chance: u8,
    // The chance of cloudly days during the summer
    pub summer_cloudy_chance: u8,
    // The chance of sunny days during the summer
    pub summer_sunny_chance: u8,
    // The chance of rain during the winter
    pub winter_rain_chance: u8,
    // The chance of snow during the winter
    pub winter_snow_chance: u8,
    // The chance of fog during the winter
    pub winter_fog_chance: u8,
    // The chance of cloudy days during the winter
    pub winter_cloudy_chance: u8,
    // The chance of sunny days during the winter
    pub winter_sunny_chance: u8,
}

#[derive(Component)]
pub struct EloComponent {
    // The ELO for the country in continental rankings. Usually a
    // measure of the territory's top league. OPTIONAL as territory
    // may not have a league system at all.
    pub league_elo: Option<f32>,
    // The ELO for the country in a global setting. Useful for rankin
    // territory's relative ranking to the entire world. OPTIONAL as
    // the territory may not have a league system at all.
    pub global_elo: Option<f32>,
    // The ELO for the country's national team. Synonymous to FIFA's
    // National Team Rankings. Mandatory for every territory as every
    // active territory will automatically have a national team.
    pub national_elo: f32,
}

// The population of a geographical location
#[derive(Component)]
pub struct PopulationComponent {
    // The raw estimate of the location's population
    pub population: u64,
}

// The area of a geographical location
#[derive(Component)]
pub struct AreaComponent {
    // The area is recorded in values of KM^2. Can be easily
    // converted to other measurement systems
    pub area: u64,
}

// The area of a geographical location
#[derive(Component)]
pub struct GDPComponent {
    // The gdp is recorded in US dollars. Can be easily
    // converted to other currencies
    pub gdp: u64,
}

// The language spoken in a location
#[derive(Component)]
pub struct LanguageComponent {
    // The language id, mainly used for the database
    pub id: u32,
    // The language name
    pub language: String,
}

// The enthusiasm of a geographical location for the
// sport of Association Football. Ranges from 1 to 5
#[derive(Component)]
pub struct EnthusiasmComponent {
    // The enthusiasm of the territory
    pub enthusiasm: u8,
}

// A quick bool check if a city is the capital of a territory
#[derive(Component)]
pub struct IsCapitalComponent {}
