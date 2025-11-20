class_name PreMatch
extends MatchState
## The Pre Match State for the football match.
##
## This state is responsible for when the match scene is entered for the first time.
## During this state, we will display cutscenes before the match starts. 
## We enter and exit this state once, to DeadBall (Kickoff) to start the match

func _on_enter(_data: Dictionary) -> void:
	# TODO: Entering this state should start intro cutscenes
	# 1. Player Walk-in
	# 2. National Anthems
	# 3. Preparing for Kickoff
	return
	
func _on_exit(_data: Dictionary) -> void:
	return

func handle_input(event: InputEvent) -> MatchState:
	
	# TODO: Change this a true key to start, likely a button combo to skip cutscenes
	# For now, we use spacebar to simulate skipping cutscene
	if event.is_action_pressed("ui_accept"): # Spacebar to start
		print("Action: Match Started.")
		# Transition to DeadBall with Kickoff context
		var context = { "type": DeadBallType.KICKOFF }
		manager.transition_to(manager.state_dead_ball, context)
		return null
	return null
