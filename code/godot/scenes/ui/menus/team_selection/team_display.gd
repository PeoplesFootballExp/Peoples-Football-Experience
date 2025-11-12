extends GridContainer

# Currently selected item index or ID
var selected_index: int = -1
var selected_team_id: int = -1

# Optional signal for when a team is selected
signal team_selected(team_id)

func _ready():
	# Connect all TeamPanel buttons
	for i in range(get_child_count()):
		var team_panel = get_child(i)
		if team_panel.has_method("get_team_id"):
			team_panel.connect("pressed", Callable(self, "_on_team_pressed").bind(i))

# Called when a TeamPanel is pressed
func _on_team_pressed(index: int):
	select_index(index)

# Select a team by index
func select_index(index: int):
	if index < 0 or index >= get_child_count():
		return

	# Unhighlight previous selection
	if selected_index >= 0:
		var prev_panel = get_child(selected_index)
		prev_panel.set_selected(false)  # TeamPanel should have set_selected(bool)

	# Highlight new selection
	var new_panel = get_child(index)
	new_panel.set_selected(true)

	selected_index = index
	selected_team_id = new_panel.get_team_id()  # Implement get_team_id() in TeamPanel

	emit_signal("team_selected", selected_team_id)

# Optional: get selected team ID
func get_selected_team_id() -> int:
	return selected_team_id
