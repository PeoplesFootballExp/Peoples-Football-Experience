extends Node

## The InputRouter is an Autoload (Singleton) that acts as a gatekeeper.
## It ensures that raw inputs are sent to the correct high-level system.
## This autoload supports up to 8 players local multiplayer. Only 1 keyboard
## and any number of gamepads.


## The internal reference to the Input Interpreter of the currently controlled
## football player 
var _keyboard_device: Control = null

## The internal references to the various Input Interpreters of all currently
## controller football players. 
## Keys: Device ID of input device
## Values: Reference to Input Interpreter
var _gamepad_devices: Dictionary[int, Control]

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
	# Initial focus is usually the Main Menu (UI)
	set_input_target(InputTarget.GAMEPLAY)

## Use this function to swap focus (e.g., when the whistle blows)
func set_input_target(target: InputTarget):
	_current_target = target
	return

## The _unhandled_input ensures we don't steal inputs that 
## UI elements (like buttons) have already consumed.
func _unhandled_input(event: InputEvent):
	match _current_target:
		InputTarget.GAMEPLAY:
			_route_to_gameplay(event)
		InputTarget.UI:
			return
		InputTarget.CUTSCENE:
			# Only allow "Skip" button or ignore all
			if event.is_action_pressed("tm_run") and event.is_action_pressed("tm_short"):
				_skip_cutscene()

func _route_to_gameplay(event: InputEvent):
	# Check if Device was saved, if not, then add to device list 
	if !_gamepad_devices.has(event.device):
		print("Device not Registered")
		
	
	_gamepad_devices[event.device].process_raw_input(event)
	
	
	
	
	
	
	
	if active_human_controller:
		# We pass the raw event to the HumanController's state machine
		# (The Pending/Hold/Double-tap logic)
		active_human_controller.process_raw_input(event)
	else:
		push_warning("InputRouter: Gameplay focus active but no HumanController assigned!")



func _skip_cutscene():
	# Trigger signal to MatchManager to skip
	print("InputRouter: Skipping cutscene...")

## Helper to register the controller from the MatchManager
func register_input_interpreter(device_id: int, controller_node: Control) -> void:
	if device_id == 0:
		_keyboard_device = controller_node
		
	_gamepad_devices[device_id] = controller_node
