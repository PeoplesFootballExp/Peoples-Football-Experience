extends Node3D
## In charge of handling dynamic attritbutes of the player during a game.
##
## Controls and Handles the position changes, stamin wears out, and if a player
## gets injured during a match



# ---------------------------------------------------------
# Dynamic Tactics
# --------------------------------------------------------- 
var _position: int;
var _role: int;

# ---------------------------------------------------------
# Dynamic Attributes
# ---------------------------------------------------------
var stamina: int;
var injured: bool;

# ---------------------------------------------------------
# Red and Yellows Cards
# ---------------------------------------------------------
var red_cards: bool = false;
var yellow_cards: int = 0;
