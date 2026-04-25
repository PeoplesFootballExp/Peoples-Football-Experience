extends Node

## The InputRouter is an Autoload (Singleton) that acts as a gatekeeper.
## It ensures that raw inputs are sent to the correct high-level system.

enum InputTarget {
	NONE,
	GAMEPLAY,
	UI,
	CUTSCENE
}

# Current state of the input focus
var current_target: InputTarget = InputTarget.UI

# References to the active controllers
# These will be set by your MatchManager when a game starts
var active_human_controller = null
var active_ui_root = null

var last_button: InputEvent = null



func _ready():
	# Initial focus is usually the Main Menu (UI)
	set_input_target(InputTarget.GAMEPLAY)

## Use this function to swap focus (e.g., when the whistle blows)
func set_input_target(target: InputTarget):
	current_target = target
	print("InputRouter: Focus shifted to ", InputTarget.keys()[target])

## The _unhandled_input ensures we don't steal inputs that 
## UI elements (like buttons) have already consumed.
func _unhandled_input(event: InputEvent):
	last_button = event
	match current_target:
		InputTarget.GAMEPLAY:
			_route_to_gameplay(event)
		InputTarget.UI:
			_route_to_ui(event)
		InputTarget.CUTSCENE:
			# Only allow "Skip" button or ignore all
			if event.is_action_pressed("ui_cancel"):
				_skip_cutscene()

func _route_to_gameplay(event: InputEvent):
	if active_human_controller:
		# We pass the raw event to the HumanController's state machine
		# (The Pending/Hold/Double-tap logic)
		active_human_controller.process_raw_input(event)
	else:
		push_warning("InputRouter: Gameplay focus active but no HumanController assigned!")

func _route_to_ui(event: InputEvent):
	# Standard Godot UI usually handles itself via _input, 
	# but you can add custom global UI shortcuts here (e.g. F12 for screenshot)
	pass

func _skip_cutscene():
	# Trigger signal to MatchManager to skip
	print("InputRouter: Skipping cutscene...")

# Helper to register the controller from the MatchManager
func register_human_controller(controller_node):
	active_human_controller = controller_node
