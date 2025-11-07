extends VBoxContainer

enum SelectionPhase { SELECT_PLAYER, SELECT_OPPONENT, READY }
var selection_phase = SelectionPhase.SELECT_PLAYER

const MAIN_SCENE: String = "res://scenes/main/main_menu.tscn";

## Nodes
@onready
var confed_selection: OptionButton = $FilterPanel/ConfedSelection;

@onready
var terr_selection : OptionButton = $FilterPanel/TerritorySelection

var player_team_id: int;
var opponent_team_id: int;

func _ready() -> void:
	#SaveManager.create_new_save(1, "Testing");
	load_confederations_button()
	load_territories_button()

func load_confederations_button() -> void:
	var popm: PopupMenu = confed_selection.get_popup();
	
	
	SaveManager.activate_save(1);
	DBManager.init_db(SaveManager.get_active_db_path());
	
	# Get all confederations
	var confeds: Array = DBManager.query_rows("SELECT * FROM Confederation")
	
	# Example: print each confed's info
	var index = 0;
	for confed in confeds:
		# Add Text Item
		confed_selection.add_item(confed["name_official"], index);
		
		# Add Icon
		var logo_path = "res://icon.svg" if confed["logo_path"] == null else confed["logo_path"]
		var tex = load(logo_path)
		if tex and tex is Texture2D:
			confed_selection.add_item(confed["name_official"])      # add the label
			confed_selection.set_item_icon(index, tex)     # assign the texture as icon
		else:
			push_error("Failed to load texture: %s" % confed["logo_path"])
		
			
		popm.set_item_icon_max_width(index, 50)
		index += 1;
		
func load_territories_button() -> void:
	
	var popm: PopupMenu = confed_selection.get_popup();
	SaveManager.activate_save(1);
	DBManager.init_db(SaveManager.get_active_db_path());
	
	# Get all confederations
	var terrs: Array = DBManager.query_rows("SELECT * FROM Territory")
	
	# Example: print each confed's info
	var index = 0;
	for terr in terrs:
		# Add Text Item
		terr_selection.add_item(terr["name"], index);
		
		# Add Icon
		var logo_path = "res://icon.svg" if terr["logo_path"] == null else terr["logo_path"]
		var tex = load(logo_path)
		if tex and tex is Texture2D:
			terr_selection.add_item(terr["name"])      # add the label
			terr_selection.set_item_icon(index, tex)     # assign the texture as icon
		else:
			push_error("Failed to load texture: %s" % terr["logo_path"])
		
			
		popm.set_item_icon_max_width(index, 50)
		index += 1;
	
	
	


## Go Back to Previous Scene
func _on_back_button_pressed() -> void:
	SceneManager.change_scene(MAIN_SCENE);
	
