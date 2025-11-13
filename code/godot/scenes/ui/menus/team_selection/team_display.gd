extends GridContainer
class_name VirtualTeamGrid

# === CONFIGURATION ===
@export var visible_rows: int = 6
@export var visible_cols: int = 8
@export var row_height: int = 160
@export var scroll_container_path: NodePath
@export var tile_scene: PackedScene
@export var lazy_load_delay: float = 0.15 # seconds

# === INTERNAL STATE ===
var scroll_container: ScrollContainer
var all_teams: Array = []         # All cached teams
var filtered_teams: Array = []    # Filtered teams
var visible_tiles: Array = []     # Pool of pre-instantiated tiles
var top_index: int = 0
var current_filters: Dictionary[String, int]= {
	"Confed": -1,
	"Terr": -1,
	"Gender": 0,
	"TeamType": 0,
}
var search_text: String = ""

# === LAZY LOAD CONTROL ===
var load_timer: Timer
#var icon_cache := {} # { logo_path: Texture2D }

func _ready() -> void:
	if scroll_container_path == NodePath():
		push_error("VirtualTeamGrid: Missing scroll_container_path")
		return

	scroll_container = get_node(scroll_container_path)
	scroll_container.connect("scroll_changed", Callable(self, "_on_scroll_changed"))

	# Timer for lazy load
	load_timer = Timer.new()
	load_timer.one_shot = true
	add_child(load_timer)
	load_timer.connect("timeout", Callable(self, "_load_visible_icons"))

	# Pre-instantiate tile pool
	var total_tiles := visible_rows * visible_cols + visible_cols * 2
	for i in range(total_tiles):
		var tile = tile_scene.instantiate()
		add_child(tile)
		visible_tiles.append(tile)

	_apply_filters()


# === FILTER HANDLING ===
func set_filter(key: String, value) -> void:
	current_filters[key] = value
	_apply_filters()


func _apply_filters() -> void:
	filtered_teams = all_teams.filter(func(team):
		if team["gender"] != current_filters["Gender"]:
			return false
		if team["team_type"] != current_filters["TeamType"]:
			return false
		if team["territory_id"] != current_filters["Terr"]:
			return false
		if team["confed_id"] != current_filters["Confed"]:
			return false
		return true
	)

	scroll_container.scroll_vertical = 0
	top_index = 0
	_update_visible_tiles(0)


# === VIRTUAL SCROLLING ===
func _on_scroll_changed() -> void:
	if !is_inside_tree():
		return

	var scroll_y := scroll_container.scroll_vertical
	var new_top_index := int(scroll_y / row_height) * visible_cols
	if new_top_index != top_index:
		top_index = new_top_index
		_update_visible_tiles(top_index)


func _update_visible_tiles(start_index: int) -> void:
	var total := filtered_teams.size()
	for i in range(visible_tiles.size()):
		var data_index := start_index + i
		var tile = visible_tiles[i]

		if data_index < total:
			var team = filtered_teams[data_index]
			tile.visible = true
			tile.metadata = team["id"]
			tile.set_tile_and_icon(team["name"], null) # text only for now
		else:
			tile.visible = false

	# Reset lazy load timer
	if load_timer.is_stopped():
		load_timer.start(lazy_load_delay)
	else:
		load_timer.start(lazy_load_delay) # restart delay each scroll


# === LAZY ICON LOADING ===
func _load_visible_icons() -> void:
	for tile in visible_tiles:
		if !tile.visible:
			continue
			
		var logo_path: String = filtered_teams.filter(func(team): return team["id"] == tile.metadata)[0]["logo_path"]

		if not logo_path or logo_path == "":
			continue

		var icon: Texture2D = null

		# Check cache first
		icon = AssetManager.load_asset(logo_path, false)
		
		if icon:
			tile.set_icon(icon)
