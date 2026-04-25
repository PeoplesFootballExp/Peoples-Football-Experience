extends Node

## Translates Godot InputEvents into a unified GameCommand signal.
## Attached to a player-controlled entity or a global Input Manager.

# --- Signals ---
signal command_issued(command: GameCommand)
signal movement_intent_updated(direction: Vector2)
signal power_updated(percent: float)

# --- Configuration ---
@export var tap_window: float = 0.18      # Time window for a double-tap
@export var power_max_time: float = 0.8   # Time to reach 100% power
@export var deadzone: float = 0.15        # Joystick deadzone

# --- Internal State ---
enum PressState { IDLE, PENDING, POWERING }

var _timers = {}         # action_name: float
var _states = {}         # action_name: PressState
var _modifier_mask: int = 0

func _process(delta: float) -> void:
	_update_modifiers()
	_update_timers(delta)
	_broadcast_movement()

## Receives input from the InputRouter
func process_raw_input(event: InputEvent) -> void:
	var actions = ["pass", "shoot", "knock_on", "through_ball"]
	
	for action in actions:
		if event.is_action_pressed(action):
			_on_action_pressed(action)
		elif event.is_action_released(action):
			_on_action_released(action)

# --- Logic: Press & Power ---

func _on_action_pressed(action: String) -> void:
	if _states.get(action, PressState.IDLE) == PressState.PENDING:
		# Double-tap detected
		_finalize_command(action, 0.5, true)
		_reset_action(action)
	else:
		_states[action] = PressState.PENDING
		_timers[action] = 0.0

func _on_action_released(action: String) -> void:
	if _states.get(action) == PressState.POWERING:
		# Released after charging
		var power = clamp(_timers[action] / power_max_time, 0.1, 1.0)
		_finalize_command(action, power, false)
		_reset_action(action)

func _update_timers(delta: float) -> void:
	for action in _states.keys():
		if _states[action] == PressState.IDLE: continue
		
		_timers[action] += delta
		
		if _states[action] == PressState.PENDING:
			if _timers[action] >= tap_window:
				if Input.is_action_pressed(action):
					_states[action] = PressState.POWERING
				else:
					# Standard single tap
					_finalize_command(action, 0.2, false)
					_reset_action(action)
		
		if _states[action] == PressState.POWERING:
			power_updated.emit(clamp(_timers[action] / power_max_time, 0.0, 1.0))

# --- The Signal Bridge ---

func _finalize_command(action_name: String, power: float, is_double: bool) -> void:
	var cmd = GameCommand.new()
	
	cmd.action = _get_action_enum(action_name)
	cmd.power = power
	cmd.is_double_tap = is_double
	cmd.modifier_mask = _modifier_mask
	
	# Aiming snapshot
	cmd.aim_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	cmd.timestamp = Time.get_ticks_msec()
	
	# Emit the finished command for whoever is listening
	command_issued.emit(cmd)
	
	# Reset UI
	power_updated.emit(0.0)

func _broadcast_movement() -> void:
	var move_vec = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if move_vec.length() < deadzone: 
		move_vec = Vector2.ZERO
	
	movement_intent_updated.emit(move_vec)

# --- Helpers ---

func _update_modifiers() -> void:
	var mask = 0
	if Input.is_action_pressed("tm_run"): mask |= 1
	if Input.is_action_pressed("tm_short"): mask |= 2
	if Input.is_action_pressed("tm_push"): mask |= 4
	if Input.is_action_pressed("sprint"): mask |= 8
	_modifier_mask = mask

func _get_action_enum(action_name: String) -> int:
	match action_name:
		"pass": return GameCommand.ActionType.PASS
		"shoot": return GameCommand.ActionType.SHOOT
		"knock_on": return GameCommand.ActionType.KNOCK_ON
		"through_ball": return GameCommand.ActionType.THROUGH_BALL
	return GameCommand.ActionType.NONE

func _reset_action(action: String) -> void:
	_states[action] = PressState.IDLE
	_timers[action] = 0.0
