class_name Tournament
extends Resource

## The unique ID of the tournament
@export var id: int;

## The commonly used name for the tournament
@export var name: String;

## The path for the tournament's logo
@export var logo_path: String;

## The ID of the territory that the tournament belongs to 
## Exclusive to confed_id
@export var territory_id: int;

## The ID of the Confederation that the tournament belongs to.
## Exlusive to territory_id 
@export var confed_id: int;

## The official name for the tournament
@export var official_name: String;

## The FOUR letter code for the tournament
@export var code: String;

## The gender of the tournament 
## (e.g Men's Tournament or Women's Tournament)
@export var gender: int;

## The type of tournament, ID to tournament type table
@export var type: int;

## The level of tournament, useful for league pyramids or hierarchal
## tournament systems
@export var level: int;

## The type of teams that can enter: 0 for clubs, 1 for National Teams
@export var team_type: int;
