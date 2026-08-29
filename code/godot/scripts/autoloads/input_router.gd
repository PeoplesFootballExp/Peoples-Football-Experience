extends Node

## The InputRouter is an Autoload (Singleton) that acts as a gatekeeper.
## It ensures that raw inputs are sent to the correct high-level system.
## This autoload supports up to 8 players local multiplayer. Only 1 keyboard
## and any number of gamepads.

## The internal references to the various Input Interpreters of all currently
## controller football players. 
## Keys: Device ID of input device
## Values: Reference to Input Interpreter
var _gamepad_devices: Dictionary[int, InputInterpreter]

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
	var device_id: int = _get_event_device_id(event)
	match _current_target:
		InputTarget.GAMEPLAY:
			_route_to_gameplay(event)
		InputTarget.UI:
			if !_gamepad_devices.has(device_id):
				register_input_interpreter(device_id);
			
		InputTarget.CUTSCENE:
			# Only allow "Skip" button or ignore all
			if event.is_action_pressed("mod_lofted") and event.is_action_pressed("mod_curled"):
				_skip_cutscene()
				
	print(event.as_text())

func _route_to_gameplay(event: InputEvent):
	# Check if Device was saved, if not, then add to device list 
	if !_gamepad_devices.has(event.device):
		print("Device not Registered")
		
	
	print(event.as_text())
	

func _skip_cutscene():
	# Trigger signal to MatchManager to skip
	print("InputRouter: Skipping cutscene...")

## Helper to register the controller from the MatchManager
func register_input_interpreter(device_id: int) -> void:
	# Create a new Input Interpreter
	var new_interpreter = InputInterpreter.new();
	
	# Save it to the router dictionary
	_gamepad_devices[device_id] = new_interpreter
	
	# Send signal for debugging purposes
	emit_signal("created_interpreter", device_id)
	
	
