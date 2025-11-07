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

func load_confederations_button(confed_filter: String) -> void:
	var popm: PopupMenu = confed_selection.get_popup();
	
	SaveManager.activate_save(1);
	DBManager.init_db(SaveManager.get_active_db_path());
	
	# Get all confederations
	var confeds: Array = DBManager.query_rows("SELECT * FROM Confederation")
	
	# Fill the option button
	Utils.populate_option_button(confed_selection, confeds, "name_official", "logo_path")
		

func load_territories_button() -> void:
	
	var popm: PopupMenu = confed_selection.get_popup();
	SaveManager.activate_save(1);
	DBManager.init_db(SaveManager.get_active_db_path());
	
	# Get all confederations
	var terrs: Array = DBManager.query_rows("SELECT * FROM Territory")
	
	# Fill Option Button
	Utils.populate_option_button(terr_selection, terrs, "name", "logo_path")
		

## Go Back to Previous Scene
func _on_back_button_pressed() -> void:
	SceneManager.change_scene(MAIN_SCENE);
	
