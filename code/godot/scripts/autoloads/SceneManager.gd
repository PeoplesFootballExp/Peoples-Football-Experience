extends Node

## -------------------------------
## SceneManager.gd
## Handles all scene transitions.
## Does NOT store gameplay data.
## -------------------------------

@export var fade_layer_scene: PackedScene   # Optional fade overlay
var _fade_layer: CanvasLayer
var _current_scene: Node


func _ready() -> void:
	# Ensure there’s a fade layer if one is provided
	if fade_layer_scene:
		_fade_layer = fade_layer_scene.instantiate()
		get_tree().root.add_child(_fade_layer)


# -------------------------------
# Load a new scene immediately
# -------------------------------
func change_scene(scene_path: String) -> void:
	_cleanup_current_scene()
	_load_new_scene(scene_path)


# -------------------------------
# Load a new scene with fade transition
# -------------------------------
func transition_to(scene_path: String, duration := 0.5) -> void:
	if not fade_layer_scene:
		change_scene(scene_path)
		return

	await _fade_out(duration)
	change_scene(scene_path)
	await _fade_in(duration)


# -------------------------------
# Private helpers
# -------------------------------

func _load_new_scene(scene_path: String) -> void:
	var packed_scene := load(scene_path)
	if not packed_scene:
		push_error("SceneManager: Could not load %s" % scene_path)
		return

	_current_scene = packed_scene.instantiate()
	get_tree().root.add_child(_current_scene)


func _cleanup_current_scene() -> void:
	if _current_scene and is_instance_valid(_current_scene):
		_current_scene.queue_free()
		_current_scene = null


# Optional fade helpers (only work if fade_layer_scene is defined)
func _fade_out(duration: float) -> void:
	if not _fade_layer: return
	if _fade_layer.has_method("fade_out"):
		await _fade_layer.fade_out(duration)


func _fade_in(duration: float) -> void:
	if not _fade_layer: return
	if _fade_layer.has_method("fade_in"):
		await _fade_layer.fade_in(duration)
