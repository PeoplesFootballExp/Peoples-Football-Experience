class_name DeadBall
extends MatchState
## The In Play State for the football match.
##
## This state is responsible for when the match scene is in open field play.
## For the most part, most of the match will be in this state, meaning most logic
## for the FSM will exist here.


# ---------------------------------------------------------
# Mini States
# ---------------------------------------------------------
## The current (or last) type of Deadball. By default, it is set to kickoff
var deadball_type: int = DeadBallType.KICKOFF


# ---------------------------------------------------------
# Dead Ball Specific Values
# ---------------------------------------------------------






func _on_enter(_data: Dictionary) -> void:
	
	
	
	
	
	return

func _on_exit(_data: Dictionary) -> void:
	pass
