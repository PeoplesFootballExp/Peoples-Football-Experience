extends Resource
class_name MatchState

# We use a reference to the manager to access score/time/players
var manager: MatchManager

# MatchPhase Enum
enum MatchPhase {
	FIRST_HALF = 0,
	SECOND_HALF = 1,
	ET_FIRST_HALF = 2,
	ET_SECOND_HALF = 3,
}

enum DeadBallType {
	NONE = 0,
	KICKOFF = 1,
	THROW_IN = 2,
	CORNER = 3,
	GOAL_KICK = 4,
	FREE_KICK = 5,
	PENALTY = 6,
	DROP_BALL = 7, 
}

# --- VIRTUAL METHODS (Override these in specific states) ---

# Called when entering the state
func enter(_manager: MatchManager, _data: Dictionary = {}):
	manager = _manager
	_on_enter(_data)

# Called when exiting the state
func exit():
	_on_exit()
	manager = null # CRITICAL: Breaks the circular dependency

# Process loop (Logic)
func process(delta: float) -> MatchState:
	return null # Return null to stay in current state, or a new State to transition

# Input handling
func handle_input(event: InputEvent) -> MatchState:
	return null

# --- INTERNAL IMPLEMENTATION ---
func _on_enter(_data: Dictionary): pass
func _on_exit(): pass
