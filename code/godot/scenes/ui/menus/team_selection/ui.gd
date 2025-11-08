extends VBoxContainer

enum SelectionPhase { SELECT_PLAYER, SELECT_OPPONENT, READY }
var selection_phase = SelectionPhase.SELECT_PLAYER

const MAIN_SCENE: String = "res://scenes/main/main_menu.tscn";


## Buttons
@onready 
var confed_button: OptionButton = %ConfedSelection;

@onready 
var terr_button: OptionButton = %TerritorySelection;

@onready
var gender_button: CheckButton = $FilterPanel/GenderSelection

@onready
var league_button: OptionButton = %LeagueSelection;

@onready
var team_grid: GridContainer = $ScrollContainer/GridContainer

@onready
var confirm_button: Button = $FooterPanel/ConfirmButton

@onready
var phase_label: Label = $HeaderPanel/TitleLabel



## Selection Options
var selected_options: Dictionary[String, int] = {
	"Confed": 1, # ID of 1 is of the world
	"Terr": -1, # -1 means none selected
	"Gender": 0, # Men is 0, Women is 1
	"League": -1, # -1 means none selected
	"Phase": selection_phase, # 0 is selecting user, 1 selecting opp, and 2 confirmed
	"Team": -1,
	"UserTeam": - 1, # -1 means none selected
	"OppTeam": -1, # -1 means none selected
}

const HIERARCHY: Dictionary[String, Array] = {
	"Confed": ["Terr"],
	"Terr": ["League"],
	"Gender": ["League"],
	"League": ["Team"],
}



const TERRITORY_QUERY: String = """
		WITH RECURSIVE confed_tree AS (
		    -- Start with the top-level confederation
		    SELECT id
		    FROM Confederation
		    WHERE id = {0}

		    UNION ALL

		    -- Recursively get child confederations
		    SELECT c.id
		    FROM Confederation c
		    INNER JOIN confed_tree ct ON c.parent_id = ct.id
		)
		SELECT t.*
		FROM Territory t
		INNER JOIN confed_tree ct ON t.confed_id = ct.id;
		"""
const CONFED_QUERY: String = "SELECT * FROM Confederation WHERE Confederation.level = 1"


func _ready() -> void:
	# Create a new save, only for testing
	# TODO: Move this to save file selection and creation scene
	#SaveManager.create_new_save(1, "Testing");
	
	# Activat the current save file, for now just use slot 1
	# TODO: Move to a save file selection scene
	SaveManager.activate_save(1);
	
	# Initiate the DB Connection
	DBManager.init_db(SaveManager.get_active_db_path());
	
	# Populate the confed and terr option buttons with all options
	_load_confeds()
	_load_terrs()


func option_selection_made(option_type: String, new_id: int) -> void:
	# Update the selected value
	selected_options[option_type] = new_id
	
	# Carry out options resets
	if HIERARCHY.has(option_type):
		for dependent_option in HIERARCHY[option_type]:
			_reset_lower_option(dependent_option)
			match dependent_option:
				"Terr":
					_load_terrs()
				"League":
					# Load leagues
					_load_leagues()
				"Team":
					#load team
					_load_teams()

func _reset_lower_option(from_option: String) -> void:
	match from_option:
		"Terr":
			selected_options["Terr"] = -1
			selected_options["League"] = -1
			selected_options["Team"] = -1
		"League":
			selected_options["League"] = -1
			selected_options["Team"] = -1
		"Team":
			selected_options["Team"] = -1

func _update_team_grid() -> void:
	var confed_id = selected_options["Confed"]
	var terr_id = selected_options["Terr"]
	var gender = selected_options["Gender"]
	var league_id = selected_options["League"]

	## Fetch teams based on filters
	#var teams = get_filtered_teams(confed_id, terr_id, gender, league_id)
#
	## Update UI
	#team_grid.populate(teams)
#
	## Highlight selections if we’re in CONFIRM_READY phase
	#if selected_options["Phase"] == "CONFIRM_READY":
		#team_grid.highlight_team(selected_options["UserTeam"], Color.GREEN)
		#team_grid.highlight_team(selected_options["OppTeam"], Color.RED)
	
func _update_phase_ui() -> void:
	match selected_options["Phase"]:
		SelectionPhase.SELECT_PLAYER:
			confirm_button.text = "Confirm User Team"
			phase_label.text = "Select your team"
		SelectionPhase.SELECT_OPPONENT:
			confirm_button.text = "Confirm Opponent Team"
			phase_label.text = "Select opponent team"
		SelectionPhase.READY:
			confirm_button.text = "Start Match"
			phase_label.text = "Ready to play!"

""" Reset Option Buttons """

func _load_confeds() -> void:
	# Get all confederations
	var confeds: Array[Dictionary] = DBManager.query_rows(CONFED_QUERY)
	
	# Fill the option button
	Utils.populate_option_button(confed_button, confeds, "name_official", "logo_path")
		

func _load_terrs() -> void:
	# Get all territories (or filter by confed_id)
	var terrs: Array[Dictionary] = DBManager.query_rows(TERRITORY_QUERY.format([str(selected_options["Confed"])]));
	
	# Fill Option Button
	Utils.populate_option_button(terr_button, terrs, "name", "logo_path")
		
		
func _load_leagues() -> void:
	pass
	
func _load_teams() -> void:
	pass

## Go Back to Previous Scene
func _on_back_button_pressed() -> void:
	SceneManager.change_scene(MAIN_SCENE);
	
## Confed Selected from Option Button
func _on_confed_selection_item_selected(index: int) -> void:
	# Get Metadata of selection
	var confed_id: int = confed_button.get_item_metadata(index);
	
	# Get ID of Confed choosen, reset Territory Option Button
	option_selection_made("Confed", confed_id);

## Terr Selected from Option Button
func _on_territory_selection_item_selected(index: int) -> void:
	# Get Metadata of selection
	var terr_id: int= terr_button.get_item_metadata(index);
	
	# Get ID of Confed choosen, reset Tournament Option Button
	option_selection_made("Terr", terr_id)
	
	# TODO: Write function to populate tournament option button
	
	
func _on_gender_selection_toggled(toggled_on: bool) -> void:
	if toggled_on:
		option_selection_made("Gender", 1)
	else:
		option_selection_made("Gender", 0)


func _on_confirm_button_pressed() -> void:
	match selected_options["Phase"]:
		SelectionPhase.SELECT_PLAYER:
			var team_id = selected_options["Team"]
			if team_id == -1:
				print("Please select a team first.")
				return
			selected_options["UserTeam"] = team_id
			selected_options["Phase"] = SelectionPhase.SELECT_OPPONENT
			print("User team confirmed:", team_id)
			_update_phase_ui()

		SelectionPhase.SELECT_OPPONENT:
			var team_id = selected_options["Team"]
			if team_id == -1:
				print("Please select a team first.")
				return
			selected_options["OppTeam"] = team_id
			selected_options["Phase"] = SelectionPhase.READY
			print("Opponent team confirmed:", team_id)
			_update_phase_ui()

		SelectionPhase.READY:
			if selected_options["UserTeam"] == -1 or selected_options["OppTeam"] == -1:
				print("Both teams must be selected before starting.")
				return
			# TODO: Now we can switch scenes to Match or 
			# Team Management Scene Before Playing
