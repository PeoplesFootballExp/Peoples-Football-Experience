use vfs::config::*;

fn main() {
    let manifest_toml = r#"
        [locations]
        Base = "res://"
        Mod = "user://mod/"
        Global = "user://global/"
        Save = "user://save/"


        [formats]
        TeamLogo = ".webp"
        TeamKit = ".webp"
        TeamChant = ".mp4"
        TerritoryFlag = ".svg"
        PersonPortrait = ".webp"
        StadiumModel = ".gltf"
        TournamentScoreboard = ".webp"
        PersonHead = ".gltf"
        PersonArm = ".gltf"
        PersonLeg = ".gltf"
        PersonFacialHair = ".gltf"
        PersonHair = ".gltf"
        PersonShirt = ".gltf"
        PersonPant = ".gltf"
        PersonShoe = ".gltf"
        PersonGlove = ".gltf"


        [categories]
        TeamLogo = "entities/club/assets/logos/"
        TeamKit = "entities/club/assets/kits/"
        TeamChant = "entities/club/assets/chants/"
        TerritoryFlag = "entities/territory/assets/flags/"
        PersonPortrait = "entities/person/assets/portraits/"
        StadiumModel = "entities/stadium/assets/models/"
        TournamentScoreboard = "entities/tournament/assets/scoreboards/"
        PersonHead = "entities/person/assets/body_parts/heads/"
        PersonArm = "entities/person/assets/body_parts/arms/"
        PersonLeg = "entities/person/assets/body_parts/legs/"
        PersonFacialHair = "entities/person/assets/body_parts/facial_hair/"
        PersonHair = "entities/person/assets/body_parts/hair/"
        PersonShirt = "entities/person/assets/clothing/shirts/"
        PersonPant = "entities/person/assets/clothing/pants/"
        PersonShoe = "entities/person/assets/clothing/shoes/"
        PersonGlove = "entities/person/assets/clothing/gloves/"


        [fallback]
        TeamLogo = "shared/placeholders/default_teamlogo.webp"
        TeamKit = "shared/placeholders/default_teamkit.webp"
        TeamChant = "shared/placeholders/default_teamchant.mp4"
        TerritoryFlag = "shared/placeholders/default_territoryflag.svg"
        PersonPortrait = "shared/placeholders/default_personportrait.webp"
        StadiumModel = "shared/placeholders/default_stadiummodel.gltf"
        TournamentScoreboard = "shared/placeholders/default_tournamentscoreboard.webp"
        PersonHead = "entities/person/assets/body_parts/heads/"
        PersonArm = "entities/person/assets/body_parts/arms/"
        PersonLeg = "entities/person/assets/body_parts/legs/"
        PersonFacialHair = "entities/person/assets/body_parts/facial_hair/"
        PersonHair = "entities/person/assets/body_parts/hair/"
        PersonShirt = "entities/person/assets/clothing/shirts/"
        PersonPant = "entities/person/assets/clothing/pants/"
        PersonShoe = "entities/person/assets/clothing/shoes/"
        PersonGlove = "entities/person/assets/clothing/gloves/"

        [assets]
        "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11" = "res://entities/club/assets/logos/1.webp"
        "#;

    let config = PipelineConfig::from_toml(manifest_toml);
    println!("{:?}", config.unwrap());
}
