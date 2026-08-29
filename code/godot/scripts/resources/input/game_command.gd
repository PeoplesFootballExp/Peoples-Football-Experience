class_name GameplayCommand
extends RefCounted



var player_index: int = 0
var action: StringName = &""
var core_button: StringName = &""
var modifier_mask: int = 0
var is_double_tap: bool = false
var core_held_time: float = 0.0
var power_ratio: float = 0.0
var trigger_pressure: float = 0.0
var move_direction: Vector2 = Vector2.ZERO
var look_direction: Vector2 = Vector2.ZERO

func _to_string() -> String:
	return "P%d | Action: %s | Core %s | ModMask: %d | DoubleTap: %s | Power: %.0f%% | RT: %.2f | Move: %2" % [
		player_index, action, core_button, modifier_mask, is_double_tap, power_ratio * 100.0, trigger_pressure, move_direction 
	]
