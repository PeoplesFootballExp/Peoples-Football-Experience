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
	
	# TODO: Play Cutscene for Dead Ball (example ref calling penalty for penalty)
	
	# TODO: Freeze Ball's Physics and stop all player's movement
	
	# TODO: Position the Ball and Players correctly, dependent on DeadBall Type
	
	# TODO: Update Camera and UI as needed, dependent on DeadBall Type
	
	
	return
	
func process(delta: float) -> MatchState:
	
	# TODO: Input Manager will allow turning of players, changing taker, etc
	
	# TODO: Input Manager will also detect when we exit this scene, as it will detect
	# when the set piece has been taken
	
	
	return

func _on_exit(_data: Dictionary) -> void:
	
	# Do the opposite of _on_enter
	# TODO: Unfreeze the ball's physics
	
	# TODO: Allow the players to move freely
	
	# TODO: Update UI and Camera as needed
	
	pass
