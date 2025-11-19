extends Node
class_name MatchManager

signal state_changed(state_name, state_data)

enum MatchPhase {
	FIRST_HALF = 0,
	SECOND_HALF = 1,
	ET_FIRST_HALF = 2,
	ET_SECOND_HALF = 3,
}

# --- MATCH DATA (Context for States to Read/Write) ---
var home_score: int = 0
var away_score: int = 0
var match_time: float = 0.0
var current_period: int = MatchPhase.FIRST_HALF
var is_knockout: bool = true # Does this match require Extra Time and Penalties?

# --- STATE MACHINE ---
var current_state: MatchState = null

# Preload all state instances. The manager owns these instances.
# NOTE: ALl of these Resources will be saved in res://scripts/resources/match_states
var state_pre_match: MatchState;
var state_dead_ball: MatchState;
var state_in_play: MatchState;
var state_goal: MatchState;
var state_break: MatchState;
var state_penalties: MatchState;
var state_completed: MatchState;

func _ready():
	# Start the FSM at the initial state
	transition_to(state_pre_match)

func _process(delta):
	if current_state:
		# Ask the current state if it wants to transition
		var next_state = current_state.process(delta)
		if next_state:
			transition_to(next_state)

func _unhandled_input(event):
	if current_state:
		# Pass input event to the current state
		var next_state = current_state.handle_input(event)
		if next_state:
			transition_to(next_state)

# --- CORE TRANSITION FUNCTION ---
func transition_to(new_state: MatchState, data: Dictionary = {}):
	if current_state:
		# 1. Exit the old state, breaking the circular reference (manager = null)
		current_state.exit()
	
	current_state = new_state
	
	if current_state:
		# 2. Enter the new state, passing a reference to self (the manager)
		pass
		
