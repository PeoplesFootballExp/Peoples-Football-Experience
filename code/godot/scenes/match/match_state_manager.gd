extends Node3D
class_name MatchManager

enum MatchPhase {FIRST_HALF, SECOND_HALF, ET_FIRST_HALF, ET_SECOND_HALF, PENALTIES}


## The Match States for the FSM. 
enum MatchState {
	SETUP = 0,
	IN_PLAY = 1,
	DEAD_BALL = 2,
	GOAL_SCORED = 3,
	HALF_TIME = 4,
	FULL_TIME = 5,
	PENALTY_SHOOTOUT = 6,
}

## Match Events: What can trigger a transition between states
enum MatchEvent {
	START_KICKOFF = 0,
	BALL_OUT_SIDELINE = 1,
	BALL_OUT_GOALLINE = 2,
	FOUL_COMMITTED = 3,
	GOAL_CONFIRMED = 4,
	DEADBALL_COMPLETED = 5,
	END_OF_HALF_WHISTLE = 6,
}

## Dead Ball Types: How the ball is out of play
enum DeadBallType {
	NONE = 0,
	THROW_IN = 1,
	CORNER_KICK = 2,
	FREE_KICK = 3,
	PENALTY = 4,
	GOAL_KICK = 5,
	DROP_BALL = 6,
}


# -------------------------------------
# State Variables
# -------------------------------------

var current_state: int = MatchState.SETUP
var current_deadball_type: int = DeadBallType.NONE
var current_phase: int = MatchPhase.FIRST_HALF
var home_score: int = 0;
var away_score: int = 0;
@export var game_clock: Timer;


func transition_state(event: MatchEvent, deadball_type := DeadBallType.NONE) -> void:
	# First, we simply transition to the next state
	var next_state: MatchState = current_state
	
	match current_state:
		MatchState.SETUP:
			if event == MatchEvent.START_KICKOFF:
				next_state = MatchState.IN_PLAY
			
	
	pass
