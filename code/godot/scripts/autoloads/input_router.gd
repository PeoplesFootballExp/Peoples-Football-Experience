extends Node

## The InputRouter is an Autoload (Singleton) that acts as a gatekeeper.
## It ensures that raw inputs are sent to the correct high-level system.
## This autoload supports up to 8 players local multiplayer. Only 1 keyboard
## and any number of gamepads.

const MAX_PLAYERS: int = 8

## The internal references to the various Input Interpreters of all currently
## controller football players. 
## Keys: Device ID of input device
## Values: Reference to Input Interpreter
var _gamepad_devices: Dictionary[int, InputInterpreter]

## The internal tracker for the players in the same device. Since there
## are a maximum of eight players, there are only eight slots here.
## The value in each index represents the Device ID for that player slot. 
var _players_devices: Array[int] = [];
var _number_of_players: int = 0


signal created_interpreter(int);

signal destroyed_interpreter(int);


## The different types of targets for input. Main ones controlled here are during
## InputTarget.GAMEPLAY and InputTarget.CUTSCENE
enum InputTarget {
	NONE,
	GAMEPLAY,
	UI,
	CUTSCENE
}

# Current state of the input focus
var _current_target: InputTarget = InputTarget.UI


func _ready():
	# Pre Allocate array slots up to MAX_PLAYERS
	_players_devices.resize(MAX_PLAYERS)
	
	# Listen for hardware connection/disconnection events
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	
	# Initial focus is usually the Main Menu (UI)
	set_input_target(InputTarget.UI)

## Use this function to swap focus (e.g., when the whistle blows)
func set_input_target(target: InputTarget):
	_current_target = target
	return

func _get_event_device_id(event: InputEvent) -> int:
	# Gamepads return 0, 1, 2... corresponding to each controller
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		return event.device
	# For Keyboard inputs returns DEVICE_ID_KEYBOARD (16)
	elif event is InputEventKey:
		return InputEvent.DEVICE_ID_KEYBOARD
	
	# Screen touch / drag returns standard touch or emulated touch (-1)
	elif event is InputEventScreenTouch or event is InputEventScreenDrag:
		return event.device
		
	return event.device

## The _unhandled_input ensures we don't steal inputs that 
## UI elements (like buttons) have already consumed.
func _unhandled_input(event: InputEvent):
	# Get Device ID of the input
	var device_id: int = _get_event_device_id(event)
	
	# First, lets check if the device ID is registered.
	var player_id = _players_devices.find(device_id)
	if player_id == -1:
		# Since we don't have it registered, we register it
		register_new_player(_number_of_players, device_id)
		player_id = _number_of_players - 1
	
	# Else, since we already have it registered, send input to 
	# input interpreter
	print(player_id, ":" , device_id)
	

## Helper to register the controller from the MatchManager
func register_new_player(player_id: int, device_id: int) -> void:
	# Register Device Id to player id
	_players_devices[player_id] = device_id
	
	# Create a new Input Interpreter
	var new_interpreter = InputInterpreter.new();
	
	# Save it to the router dictionary
	_gamepad_devices[device_id] = new_interpreter
	
	# Increment the number of players
	_number_of_players += 1
	
	# Send signal for debugging purposes
	emit_signal("created_interpreter", device_id)

func _auto_bind_gamepad(device_id: int) ->void:
	pass

func _on_joy_connection_changed(device_id: int, connected: bool) -> void:
	if connected:
		_auto_bind_gamepad(device_id)
		return
	
	if _gamepad_devices.has(device_id):
		var slot: int = _players_devices[device_id]

	

		
