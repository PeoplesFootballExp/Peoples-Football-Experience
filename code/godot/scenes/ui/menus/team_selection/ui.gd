extends VBoxContainer

enum SelectionPhase { SELECT_PLAYER, SELECT_OPPONENT, READY }
var selection_phase = SelectionPhase.SELECT_PLAYER

const MAIN_SCENE: String = "res://scenes/main/main_menu.tscn";

## Nodes
@onready
var confed_selection: OptionButton = $FilterPanel/ConfedSelection;


var player_team_id: int;
var opponent_team_id: int;

func _ready() -> void:
	#SaveManager.create_new_save(1, "Testing");
	load_confederations_button()

func load_confederations_button() -> void:
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
		
			
			
		index += 1;
		

	
	


## Go Back to Previous Scene
func _on_back_button_pressed() -> void:
	SceneManager.change_scene(MAIN_SCENE);
	
