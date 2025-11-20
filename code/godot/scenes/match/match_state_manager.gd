extends Node
class_name MatchManager

signal state_changed(state_name, state_data)

## Match Phase: The current half being played. Only four types of halves can be 
## played in Football. For the most part, most matches have only 2 halves of 45
## minutes each. For knockout matches, there may be another 2 extra time halves 
## of 30 minutes if a winner in not decided in the first 90 minutes
enum MatchPhase {
	FIRST_HALF = 0,
	SECOND_HALF = 1,
	ET_FIRST_HALF = 2,
	ET_SECOND_HALF = 3,
}

## DeadBall Types: The type of set pieces coming back from a pause to the game.
## These includes kickoff coming back from intermission, fouls (free kick, penalty),
## balls going out of bounds (corner, goal kick, throw in) or simply a drop ball.
## All these states are exclusive, but any can occur during a dead ball state
## depending on conditions when we enter.
enum DeadBallType {
	KICKOFF = 0,
	THROW_IN = 1,
	CORNER = 2,
	GOAL_KICK = 3,
	FREE_KICK = 4,
	PENALTY = 5,
	DROP_BALL = 6, 
}

## Possession: Tracks who currently has possession of the ball only during In Play 
## state. During other states, possession is not tracked so this mini state can
## only be of home possession or away possession
enum Possession {
	HOME = 0,
	AWAY = 1,
}

## Ball Height: A Helper mini state that tells us what the ball's height is.
## This can affect how a player moves such as a header or ground passes.
enum BallHeight {
	GROUND = 0,
	ABOVE_FEET = 1,
	ABOVE_HEAD = 2,
}

## Penalty Turn: A helper mini state for tracking who's turn it is to take a penalty
## during the Penalties state (aka the penalty shootout). 
enum PenaltyTurn {
	HOME_PEN = 0,
	AWAY_PEN = 1,
}

## Match Events: What can cause a transition between states of the Match.
enum MatchEvent {
	SET_KICKOFF = 0,
	PLAY_STOPS = 1,
	PLAY_CONTINUES = 2,
	GOAL_SCORED = 3,
	HALF_ENDS = 4,
	NEED_PENALTIES = 6,
	WINNER_DETERMINED = 7,
}

# --- MATCH DATA (Context for States to Read/Write) ---
var home_score: int = 0
var away_score: int = 0
var match_time: float = 0.0
var current_period: int = MatchPhase.FIRST_HALF
var is_knockout: bool = false # Does this match require Extra Time and Penalties?

# --- STATE MACHINE ---
var current_state: MatchState = null;

# Preload all state instances. The manager owns these instances.
# NOTE: ALl of these Resources will be saved in res://scripts/resources/match_states
var state_pre_match: MatchState = preload("res://scripts/resources/match_states/pre_match.gd").new();
var state_dead_ball: MatchState;
var state_in_play: MatchState;
var state_goal: MatchState;
var state_break: MatchState;
var state_penalties: MatchState;
var state_completed: MatchState;

func _ready():
	# Start the FSM at the initial state
	transition_to(state_pre_match)

func _process(delta: float):
	if current_state:
		# Ask the current state if it wants to transition
		var next_state = current_state.process(delta)
		if next_state:
			var data = {
				"Home Score": home_score,
				"Away Score": away_score,
				"Match Time": match_time,
				"Is Knockout": is_knockout,
			}
			transition_to(next_state, data)

func _unhandled_input(event):
	if current_state:
		# Pass input event to the current state
		var next_state = current_state.handle_input(event)
		if next_state:
			var data = {
				"Home Score": home_score,
				"Away Score": away_score,
				"Match Time": match_time,
				"Is Knockout": is_knockout,
			}
			transition_to(next_state, data)

# --- CORE TRANSITION FUNCTION ---
func transition_to(new_state: MatchState, data: Dictionary = {}):
	# First, we must clear any state data.
	if current_state:
		# 1. Exit the old state, breaking the circular reference (manager = null)
		current_state.exit(data)
	
	# Now we simply change state
	current_state = new_state
	
	# Now, we enter new state
	current_state.enter(self, data);
	
