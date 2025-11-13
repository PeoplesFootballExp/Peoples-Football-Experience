extends Node
class_name Utils


static func populate_option_button(button: OptionButton, data: Array[Dictionary], data_text: String, data_icon_path: String, replace := true, asset_cache:=false ) -> void:
	# Validate Field Strings
	if data_text == "" or data_icon_path == "":
		return
		
	# Make Button Invisible to avoid unecessary draw calls yet
	button.visible = false
		
	# Clear Option Button itemlist if desired
	if replace:
		button.clear()
		
	# Iterate through data, each row being a dictionary
	for row in data:
		# Load Icon, if any, else ignore
		var icon: Texture2D = AssetManager.load_asset(row[data_icon_path], asset_cache)
		if icon:
			button.add_icon_item(icon, row[data_text])
		else:
			button.add_item(row[data_text])
				
		# Set Metadata
		button.set_item_metadata(-1, row["id"])
		
	button.visible = true
			
