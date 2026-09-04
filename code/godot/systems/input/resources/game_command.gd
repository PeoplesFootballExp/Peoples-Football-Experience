class_name GameplayCommand
extends RefCounted

enum CoreButton {
	PASS,
	SHOOT,
	THROUGH_BALL,
	LOFTED_PASS,
	NONE,
}

enum ModifierFlags {
	NONE        = 0,
	MODLOFTED   = 1 << 0,             # 1: Lofted / Elevation
	MODCURLED   = 1 << 1,             # 2: Finesse / Curve
	MODFLAIR    = 1 << 2,             # 4: Flair / Skill
	MODPOWER    = (1 << 0) | (1 << 1) # 3: Driven /  Heavy
}

enum PlayerSide {
	HOME,
	AWAY,
	NONE,
}

# Player (aka device number)
var player_index: int = 0
var player_side: PlayerSide = PlayerSide.NONE

#  Core Button
var core_button: CoreButton = CoreButton.NONE

# Modifier Button Presses
var modifier_mask: ModifierFlags = ModifierFlags.NONE

# Douvle Tap
var is_double_tap: bool = false

# Button Hold Times
var core_held_time: float = 0.0
var power_ratio: float = 0.0

# Trigger Buttons Pressure
var trigger_pressure: float = 0.0

# Joystick Directional Vectors
var move_direction: Vector2 = Vector2.ZERO
var look_direction: Vector2 = Vector2.ZERO
