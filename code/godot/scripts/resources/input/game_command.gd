class_name GameCommand
extends Resource

## Exhaustive input command sent from Godot Controllers to the Rust Backend.

# --- Action Types ---
enum ActionType {
	NONE,
	SHOOT,
	PASS,
	THROUGH_BALL,
	KNOCK_ON,
	TM_RUN,
	TM_SHORT,
	TM_PUSH,
	SPRINT,
	MOVE,
	SKILL_MOVE,
}

# --- Data Fields ---
@export var action: ActionType = ActionType.NONE

## 0.0 to 1.0 (The duration of the hold)
@export var power: float = 0.0

## The left joystick direction at the exact moment the button was released.
## Essential for aiming shots independent of the player's current face direction.
@export var aim_vector: Vector2 = Vector2.ZERO

## Bitmask for modifiers: 
## Bit 0 (1): LB, Bit 1 (2): RB, Bit 2 (4): LT, Bit 3 (8): RT
@export var modifier_mask: int = 0

## True if the button was double-tapped within the timing window.
@export var is_double_tap: bool = false

## System time (ms) when command was created. Used for synchronization.
@export var timestamp: float = 0.0

# --- Helper Methods for the Frontend/Logic ---

func has_modifier(bit: int) -> bool:
	# bit should be the power of 2 (1, 2, 4, 8)
	return (modifier_mask & bit) != 0

func is_chip_shot() -> bool:
	return action == ActionType.SHOOT and has_modifier(1) # LB + B

func is_finesse_shot() -> bool:
	return action == ActionType.SHOOT and has_modifier(2) # RB + B

func is_low_driven() -> bool:
	return action == ActionType.SHOOT and is_double_tap

func get_modifier_names() -> Array:
	var names = []
	if has_modifier(1): names.append("LB")
	if has_modifier(2): names.append("RB")
	if has_modifier(4): names.append("LT")
	if has_modifier(8): names.append("RT")
	return names
