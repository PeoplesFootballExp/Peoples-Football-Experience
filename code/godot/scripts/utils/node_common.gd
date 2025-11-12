extends Node
class_name Utils


static func populate_option_button(button: OptionButton, data: Array[Dictionary], data_text: String, data_icon_path: String, replace := true ) -> void:
	# Validate Field Strings
	if data_text == "" or data_icon_path == "":
		return
		
	# Clear Option Button itemlist if desired
	if replace:
		button.clear()
		
	# Iterate through data, each row being a dictionary
	for row in data:
		## Add item with text
		button.add_item(row[data_text])
		
		# Load Icon, if any, else ignore
		if row[data_icon_path] != null:
			var icon_path: String = row[data_icon_path]
			var icon = load(icon_path)
			if icon and icon is Texture2D:
				button.set_item_icon(-1, icon)     # assign the texture as icon
			else:
				push_error("Failed to load texture: %s" % icon_path)
				
		# Set Metadata
		button.set_item_metadata(-1, row["id"])
			
		
static func populate_team_grid(grid: GridContainer, tile: PackedScene, data: Array[Dictionary], data_text: String, data_icon_path: String, replace := true ) -> void:
	# Validate Field Strings
	if data_text == "" or data_icon_path == "":
		return
		
	# Clear Option Button itemlist if desired
	if replace:
		for child in grid.get_children():
			child.queue_free()
	
	# Iterate through data, each row being a dictionary
	for row in data:
		## Add selection tile
		var tile_scene = tile.instantiate();
		grid.add_child(tile_scene)
		
		# Load Icon, if any, else ignore
		if row[data_icon_path] != null:
			var icon_path: String = row[data_icon_path]
			var icon = load(icon_path)
			if icon and icon is Texture2D:
				tile_scene.set_tile_and_icon(row["name"], icon)    # assign the texture as icon
			else:
				push_error("Failed to load texture: %s" % icon_path)
				
		# Set Metadata
		tile_scene.metadata = row["id"];
		
	
	return
