class_name Territory
extends Resource

## The Unique ID of the territory
@export var id: int;

## The commonly used name of the territory
@export var name: String;

## The path to the Flag of the territory
@export var logo_path: String;

## The ID of the territory's parent territory
@export var parent_id: int;

## The ID of the confederation this territory is part of
@export var confed_id: int;

## The official name of the territory
@export var official_name: String;

## The alternative third name of the territory
@export var alt_name: String;

## The three letter code for the territory
@export var code: String;

## The demonym for this territory (eg. Albanian)
@export var demonym: String;

## Whether this territory is active in the game. Unactive territories are not included
## in the simulation of the save
@export var is_active: int;

## The ELO of the league relative to other leagues in the continental
## confederation
@export var league_elo: float;

## The ELO of the league globally
@export var global_elo: float;

## The ELO of the national team globally for this territory
@export var national_elo: float;

## The population of this territory
@export var population: int;

## The Area (in km^2) of this territory (always rounded)
@export var area: int;

## The GDP of the territory
@export var gdp: int;

## The language primarily spoken in this country. Points to the ID of the language
@export var language_id: int;

## The general climate of the territory, dictating the probabilities of weather conditions
@export var climate_id: int;

## The hemisphere the territory is in, again, helping decide the weather
@export var hemisphere_id: int;

## The general enthusiasm of the territory for Association Football rated from
## 1 to 5
@export var enthusiasm: int;
