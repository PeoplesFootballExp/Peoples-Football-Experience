class_name InPlay
extends MatchState
## The In Play State for the football match.
##
## This state is responsible for when the match scene is in open field play.
## For the most part, most of the match will be in this state, meaning most logic
## for the FSM will exist here.

# State Variables
var current_period: int;
var ball_height: int;
var possesion: int;


func _on_enter(_data: Dictionary) -> void:
	
	
	
	
	return

func _on_exit(_data: Dictionary) -> void:
	pass
