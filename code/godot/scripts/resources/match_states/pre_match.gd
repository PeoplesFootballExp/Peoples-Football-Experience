class_name PreMatch
extends MatchState

func _on_enter(_data: Dictionary):
	print(">> PRE-MATCH: Waiting for start signal...")
	manager.home_score = 0
	manager.away_score = 0
	manager.match_time = 0.0
	manager.current_period = MatchPhase.FIRST_HALF

func handle_input(event: InputEvent) -> MatchState:
	if event.is_action_pressed("ui_accept"): # Spacebar to start
		print("Action: Match Started.")
		# Transition to DeadBall with Kickoff context
		var context = { "type": DeadBallType.KICKOFF }
		manager.transition_to(manager.state_dead_ball, context)
		return null
	return null
