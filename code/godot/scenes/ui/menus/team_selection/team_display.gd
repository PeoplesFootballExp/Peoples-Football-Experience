extends GridContainer
class_name VirtualTeamGrid

# === CONFIGURATION ===
@export var visible_rows: int = 6
@export var visible_cols: int = 8
@export var row_height: int = 160
# Add a buffer of 2 extra rows for smooth scrolling (6*8=48 visible + 2*8=16 buffer)
const SCROLL_BUFFER_ROWS: int = 2 

@export var scroll_container_path: NodePath
@export var tile_scene: PackedScene
@export var lazy_load_delay: float = 0.15 # seconds

# === INTERNAL STATE ===
var scroll_container: ScrollContainer
var all_teams: Array = []           # All cached teams
var filtered_teams: Array = []      # Currently displayed subset
var visible_tiles: Array = []       # Pool of pre-instantiated tiles (the ONLY visible nodes)
var total_teams: int = 0
var top_index: int = 0              # The data index of the first team currently in the tile pool
var current_filters: Dictionary = {
	"Confed": -1,
	"Terr": -1,
	"Gender": 0,
	"TeamType": 0,
}
var search_text: String = ""
var needs_icon_update: bool = false # Flag for deferred icon loading

#func _ready() -> void:
	#if scroll_container_path.is_empty():
		#push_error("VirtualTeamGrid: Missing scroll_container_path")
		#return
#
	#scroll_container = get_node(scroll_container_path)
	#if scroll_container:
		#scroll_container.connect("scroll_changed", Callable(self, "_on_scroll_changed"))
		#self.vertical_alignment = VERTICAL_ALIGNMENT_TOP
#
	## Set the number of columns on the GridContainer
	#columns = visible_cols 
	#
	## 1. Pre-instantiate tile pool (Visible + Buffer rows)
	#var pool_size := (visible_rows + SCROLL_BUFFER_ROWS) * visible_cols
	#for i in range(pool_size):
		#var tile = tile_scene.instantiate()
		#add_child(tile)
		#visible_tiles.append(tile)
#
	## Start the deferred icon loading process
	#set_process(true)
	#
	## NOTE: You should call a function to load all_teams here (e.g., from SQLite)
	#_apply_filters()
#
#func _process(_delta: float) -> void:
	## Defer heavy texture loading to avoid stuttering during scrolling
	#if needs_icon_update:
		## A simple check; in a real app, you might use a Timer or coroutine for true lazy loading
		#needs_icon_update = false
		#_load_visible_icons()

# === KEY VIRTUALIZATION STEP: SET CONTAINER SIZE ===
func _resize_grid_container() -> void:
	total_teams = filtered_teams.size()
	
	# Calculate total rows needed for ALL filtered teams (ceiling division)
	var total_rows = ceil(float(total_teams) / visible_cols)
	var total_height = total_rows * row_height
	
	# Set the GridContainer's custom minimum height. This makes the ScrollContainer's 
	# scrollbar appear for the full virtual height.
	custom_minimum_size.y = total_height

# === FILTER HANDLING ===
func set_filter(key: String, value) -> void:
	current_filters[key] = value
	_apply_filters()

func set_search_text(text: String) -> void:
	search_text = text.to_lower()
	_apply_filters()

func _apply_filters() -> void:
	# 1. Filter the data array
	# NOTE: The filtering logic here is an approximation. A real app would use the
	# SQL query logic from previous answers, which is much faster for large datasets.
	filtered_teams = all_teams.filter(func(team):
		# Mandatory Filters
		if team.get("gender") != current_filters["Gender"]:
			return false
		if team.get("team_type") != current_filters["TeamType"]:
			return false

		# Priority 1: Search Filter
		if not search_text.is_empty():
			return team.get("name", "").to_lower().find(search_text) != -1

		# Priority 2/3: Geographic Filters (If search is empty)
		if current_filters["Terr"] != -1 and team.get("territory_id") != current_filters["Terr"]:
			return false

		if current_filters["Confed"] != -1 and team.get("level_1_confed_id") != current_filters["Confed"]:
			return false
			
		return true
	)

	# 2. Reset scroll, update size, and refresh tiles
	_resize_grid_container()
	scroll_container.scroll_vertical = 0
	top_index = 0
	_update_visible_tiles(0)


# === VIRTUAL SCROLLING ===
func _on_scroll_changed() -> void:
	if total_teams == 0 or not is_inside_tree():
		return

	var scroll_y := scroll_container.scroll_vertical
	
	# Calculate the row we have scrolled to
	var scroll_row := int(scroll_y / row_height)
	
	# Calculate the new starting index, accounting for the 1-row buffer
	# This ensures we load the next row of data just before it becomes visible.
	var new_top_index = max(0, (scroll_row - 1) * visible_cols) 

	# Only update tiles if the starting index has changed
	if new_top_index != top_index and (new_top_index % visible_cols) == 0:
		top_index = new_top_index
		_update_visible_tiles(top_index)


func _update_visible_tiles(start_index: int) -> void:
	var pool_size := visible_tiles.size()
	
	for i in range(pool_size):
		var data_index := start_index + i
		var tile = visible_tiles[i]

		if data_index < total_teams:
			var team_data = filtered_teams[data_index]
			tile.visible = true
			
			# NOTE: The Tile Scene (tile_scene) must have a function like set_team_data(data)
			# which handles setting the text name and storing the logo_path.
			tile.set_team_data(team_data) 
			
			# Flag for icon loading
			needs_icon_update = true
		else:
			tile.visible = false
			# Clean up data from unused tiles
			tile.set_team_data(null)


# === LAZY ICON LOADING ===
# This function is now called deferred from _process()
func _load_visible_icons() -> void:
	var data_start_index = top_index 
	
	for i in range(visible_tiles.size()):
		var data_index = data_start_index + i
		var tile = visible_tiles[i]

		if not tile.visible or data_index >= total_teams:
			continue
			
		var team = filtered_teams[data_index]
		var logo_path: String = team.get("logo_path", "")

		if logo_path.is_empty():
			tile.set_icon(null) # Assuming the tile has a set_icon method
			continue

		# --- Asynchronous/Cached Loading is Crucial Here ---
		# NOTE: This assumes an 'AssetManager' singleton is available for loading
		# the Texture2D from the resource path. It should handle caching.
		
		# Example of how you would load it (should be done asynchronously in a real game)
		var icon: Texture2D = AssetManager.load_asset(logo_path, false)
		
		if icon:
			tile.set_icon(icon)
