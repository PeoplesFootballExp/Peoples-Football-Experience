extends Resource
class_name MatchState
## The State Interface for the Match Finite State Machine.
##
## Any states in the Match should extend this Resource. 


# We use a reference to the manager to access score/time/players
var manager: MatchManager


@export_category("Helper States")

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



# --- VIRTUAL METHODS  ---

# Called when entering the state
func enter(_manager: MatchManager, _data: Dictionary = {}):
	manager = _manager
	_on_enter(_data)
	return

# Called when exiting the state
func exit(_data: Dictionary):
	_on_exit(_data)
	manager = null # CRITICAL: Breaks the circular dependency
	

# Process loop (Logic)
func process(delta: float) -> MatchState:
	return null # Return null to stay in current state, or a new State to transition

# Input handling
func handle_input(event: InputEvent) -> MatchState:
	return null

# --- INTERNAL IMPLEMENTATION ---
func _on_enter(_data: Dictionary) -> void: pass
func _on_exit(_data: Dictionary) -> void: pass
