extends Node

@export var max_slots := 20

var active_save_slot: int = 0
var active_db_path: String
var active_metadata: Dictionary

# -------------------------------
# Create a new save slot
# -------------------------------
func create_new_save(slot: int, save_name: String) -> void:
	if slot < 1 or slot > max_slots:
		push_error("Invalid save slot")
		return

	# Paths
	var db_path = "user://saves/save_%03d.db" % slot
	var meta_path = "user://saves/save_%03d.json" % slot

	# Copy default database
	var default_db = "res://database/PFE_Database.db"
	if not FileAccess.file_exists(default_db):
		push_error("Default DB missing")
		return
	DirAccess.copy_absolute(default_db, db_path)

	# Write metadata JSON
	var metadata = {
		"slot": slot,
		"name": save_name,
		"timestamp": int(Time.get_unix_time_from_system()),
		"version": "0.0.1",
		"player_team_id": "",  # fill later when player selects team
		"player_team_name": "",
		"autosave_slot": false
	}

	_write_metadata(meta_path, metadata)

# -------------------------------
# Get current db path
# -------------------------------
func get_active_db_path() -> String:
	return active_db_path


# -------------------------------
# Load metadata for a save slot
# -------------------------------
func load_metadata(slot: int) -> Dictionary:
	var path = "user://saves/save_%03d.json" % slot
	if not FileAccess.file_exists(path):
		return {}
	var file = FileAccess.open(path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	if data == null:
		push_error("Failed to parse metadata JSON")
		return {}
	return data

# -------------------------------
# Activate a save slot
# -------------------------------
func activate_save(slot: int) -> void:
	active_save_slot = slot
	active_db_path = "user://saves/save_%03d.db" % slot
	active_metadata = load_metadata(slot)

# -------------------------------
# Autosave
# -------------------------------
func autosave(current_state_metadata: Dictionary) -> void:
	var db_path = "user://saves/autosave.db"
	var meta_path = "user://saves/autosave.json"

	# Copy current active DB to autosave
	DirAccess.copy_absolute(active_db_path, db_path)

	# Update metadata
	current_state_metadata["autosave_slot"] = true
	current_state_metadata["timestamp"] = int(Time.get_unix_time_from_system())
	_write_metadata(meta_path, current_state_metadata)

# -------------------------------
# Helper: Write metadata JSON
# -------------------------------
func _write_metadata(path: String, metadata: Dictionary) -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(metadata))
		file.close()

# -------------------------------
# List all saves with metadata
# -------------------------------
func list_saves() -> Array:
	var saves := []
	var dir = DirAccess.open("user://saves")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".json"):
				# file_name = "save_001.json"
				var slot_str = file_name.replace("save_", "").replace(".json", "")
				var slot = int(slot_str)
				var meta = load_metadata(slot)
				if meta != {}:
					saves.append(meta)
			file_name = dir.get_next()
		dir.list_dir_end()
	return saves
