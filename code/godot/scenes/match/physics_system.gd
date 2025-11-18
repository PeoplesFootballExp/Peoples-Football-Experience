extends Node3D


# The Ball Scene
@export var ball: RigidBody3D

# Home Players
@export var home_players: Array[CharacterBody3D];

# Away Players
@export var away_players: Array[CharacterBody3D];
