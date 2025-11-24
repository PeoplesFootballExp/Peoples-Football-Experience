class_name InPlay
extends MatchState
## The In Play State for the football match.
##
## This state is responsible for when the match scene is in open field play.
## For the most part, most of the match will be in this state, meaning most logic
## for the FSM will exist here.

# ---------------------------------------------------------
# Mini States
# --------------------------------------------------------- 

## Tracks the current period of the match. By default, we will start in the First Half
var current_period: int = MatchPhase.FIRST_HALF;

## Tracks the current height of the ball. By default, the ball starts on the ground
var ball_height: int = BallHeight.GROUND;

## Tracks the current team with possession during In Play state. By Default, the Home teams
## starts with possession.
var possesion: int = Possession.HOME;


func _on_enter(_data: Dictionary) -> void:
	
	# TODO: Check who took the set piece and assign possesion
	
	# TODO: 
	
	
	
	
	return

func _on_exit(_data: Dictionary) -> void:
	pass
