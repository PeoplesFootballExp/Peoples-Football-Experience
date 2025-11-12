extends VBoxContainer

enum SelectionPhase { SELECT_PLAYER, SELECT_OPPONENT, READY }
var selection_phase = SelectionPhase.SELECT_PLAYER

const MAIN_SCENE: String = "res://scenes/main/main_menu.tscn";
const TEAM_TILE: PackedScene = preload("res://scenes/ui/elements/selection_tile/selection_tile.tscn");

## Buttons
@onready 
var confed_button: OptionButton = %ConfedSelection;

@onready 
var terr_button: OptionButton = %TerritorySelection;

@onready
var teamtype_button: CheckButton = $FilterPanel/TeamTypeSelection

@onready
var gender_button: CheckButton = $FilterPanel/GenderSelection

@onready
var league_button: OptionButton = %LeagueSelection;

@onready
var team_grid: GridContainer = $ScrollContainer/TeamSelectionGrid

@onready
var confirm_button: Button = $FooterPanel/ConfirmButton

@onready
var phase_label: Label = $HeaderPanel/TitleLabel

@onready 
var user_team_display: PanelContainer = $MarginContainer/TeamSelectedDisplay/UserTeamDisplay

@onready 
var opp_team_display: PanelContainer = $MarginContainer/TeamSelectedDisplay/OppTeamDisplay



var search_text: String = "";



## Selection Options
var selected_options: Dictionary[String, int] = {
	"Confed": 1, # ID of 1 is of the world
	"Terr": -1, # -1 means none selected
	"Gender": 0, # Men is 0, Women is 1 
	"TeamType": 0, # Club Team is 0, National team is 1
	"League": -1, # -1 means none selected
	"Phase": selection_phase, # 0 is selecting user, 1 selecting opp, and 2 confirmed
	"Team": -1,
	"UserTeam": - 1, # -1 means none selected
	"OppTeam": -1, # -1 means none selected
}

const HIERARCHY: Dictionary[String, String] = {
	"Confed": "Terr",
	"Terr": "League",
	"TeamType": "League",
	"Gender": "League",
	"League": "Team",
	"Team": "Team"
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

const TOUR_QUERY: String = "
	WITH RECURSIVE
	    -- 1. Get the target confederation and all its children/descendants
	confed_tree (confed_id) AS (
	        -- Anchor Member: Start with the selected confederation
	        -- Uses the placeholder :confed_id
	        SELECT C.id FROM Confederation C WHERE C.id = {confed_id} 

	        UNION ALL

	        -- Recursive Member: Find children (uses parent_id from your schema)
	        SELECT c_child.id
	        FROM Confederation c_child
	        JOIN confed_tree ct ON c_child.parent_id = ct.confed_id
    )
    
	SELECT
	    T.*
	FROM
	    Tournament T
	INNER JOIN
	    Territory TR ON T.territory_id = TR.id -- Tournaments link to Territories
	WHERE
	    -- 3. Always filter by Gender AND TeamType
	    -- Note: T.gender is an INTEGER, so 'men' or 'women' might need to be replaced with 0 or 1.
	    T.gender = {gender}
		AND T.team_type = {team_type}
	    
	    -- 2. Conditional filter based on territory/confederation priority
	    AND (
	        -- CASE A: Territory is selected (Highest Priority)
	        -- Filter by the specific territory ID and ignore confed logic entirely.
	        ({terr_id} IS NOT NULL AND T.territory_id = {terr_id})
	        
	        OR
	        
	        -- CASE B & C: Territory is NOT selected (Confederation logic applies)
	        ({terr_id} IS NULL AND (
	            -- CASE C: World Confed (ID 1) selected, no geographic filter needed.
	            {confed_id} = 1 
	            OR
	            -- CASE B: Specific Confed selected, filter by recursive tree.
	            -- CORRECTED: Checks the Territory's confed_id against the recursive list.
	            TR.confed_id IN (SELECT confed_id FROM confed_tree)
	        ))
	    )
	ORDER BY
	    T.id;
"

const TEAM_QUERY: String = "
WITH RECURSIVE
    -- 1. Get the target confederation and all its children/descendants
    confed_tree (confed_id) AS (
        -- Anchor Member
        SELECT C.id FROM Confederation C WHERE C.id = {confed_id}

        UNION ALL

        -- Recursive Member
        SELECT c_child.id
        FROM Confederation c_child
        JOIN confed_tree ct ON c_child.parent_id = ct.confed_id
    )
    
SELECT
    TM.*
FROM
    Team TM
INNER JOIN
    Territory TR ON TM.territory_id = TR.id -- Team to Territory link
WHERE
    -- =================================================================
    -- A. MANDATORY BASE FILTERS (Always applied)
    -- =================================================================
    
    -- 1. Only active teams
    TM.is_active = 1
    
    -- 2. Only top-level teams (no reserves or youth teams)
    AND TM.parent_id IS NULL
    
    -- 3. Filter by Team Type (e.g., 0 for Club, 1 for National)
    AND TM.team_type = {team_type}
    
    -- 4. Filter by Gender
    AND TM.gender = {gender}
    
    -- =================================================================
    -- B. CONDITIONAL PRIORITY FILTERS (Applies ONE of the following)
    -- =================================================================
    AND (
        -- --- PRIORITY 1: SEARCH FILTER (Overrides all) ---
        -- If search term is provided, filter by name LIKE and ignore the rest of the block.
        ({search_text} IS NOT NULL AND TM.name LIKE {search_text} || '%')
        
        OR 
        
        -- --- PRIORITY 2/3: NO SEARCH TERM SELECTED (Execute if :team_search_term IS NULL) ---
        ({search_text} IS NULL AND (
        
            -- --- PRIORITY 2: TERRITORY FILTER ---
            -- If :territory_id is provided, filter by territory and ignore confed logic.
            ({terr_id} IS NOT NULL AND TM.territory_id = {terr_id})
            
            OR
            
            -- --- PRIORITY 3: CONFEDERATION FILTER (NO TERRITORY/LEAGUE) ---
            -- Execute this block ONLY if :territory_id IS NULL
            ({terr_id} IS NULL AND (
                -- CASE A: World Confed (ID 1) selected, no geographic filter.
                {confed_id} = 1 
                OR
                -- CASE B: Specific Confed selected, filter by recursive tree.
                TR.confed_id IN (SELECT confed_id FROM confed_tree)
            ))
        ))
    )
ORDER BY
    TM.id;
"
const SIMPLE_TEAM_QUERY: String = "SELECT * FROM Team WHERE id = {team_id}"

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
	#_load_leagues()
	_load_teams()


func option_selection_made(option_type: String, new_id: int) -> void:
	# Update the selected value
	selected_options[option_type] = new_id
	
	# Carry out options resets
	if HIERARCHY.has(option_type):
			#_reset_lower_option(dependent_option)
			match HIERARCHY[option_type]:
				"Terr":
					_load_terrs()
					option_selection_made("Terr", -1);
				"League":
					# Load leagues
					#_load_leagues()
					option_selection_made("Team", -1);
				"Team":
					#load team
					_load_teams()


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
	Utils.populate_option_button(confed_button, confeds, "name", "logo_path")
	
	# Display Blank Option
	confed_button.text = "Select Confederation..."


func _load_terrs() -> void:
	# Get all territories (or filter by confed_id)
	var terrs: Array[Dictionary] = DBManager.query_rows(TERRITORY_QUERY.format([str(selected_options["Confed"])]));
	
	# Fill Option Button
	Utils.populate_option_button(terr_button, terrs, "name", "logo_path")
	
	# Display Blank Option
	terr_button.text = "Select Territory..."


func _load_leagues() -> void:
	# Get All Tournaments
	var tours: Array[Dictionary] = DBManager.query_rows(TOUR_QUERY.format({
		"confed_id": selected_options["Confed"], 
		"gender": str(selected_options["Gender"]),
		"team_type": str(selected_options["TeamType"]),
		"terr_id": selected_options["Terr"] if selected_options["Terr"] > 0 else "NULL",
	}))
	
	# Fill Option Button
	Utils.populate_option_button(league_button, tours, "name", "logo_path")
		
	# Display Blank Option
	league_button.text = "Select League..."


func _load_teams() -> void:
	# Get All Teams
	var teams: Array[Dictionary] = DBManager.query_rows(TEAM_QUERY.format({
		"confed_id": selected_options["Confed"], 
		"gender": str(selected_options["Gender"]),
		"team_type": str(selected_options["TeamType"]),
		"terr_id": selected_options["Terr"] if selected_options["Terr"] > 0 else "NULL",
		"search_text": "'{text}'".format({"text": search_text}) if search_text.length() > 0  else "NULL"
		
	}))
	
	# Fill Option Button
	populate_team_grid(team_grid, TEAM_TILE, teams, "name", "logo_path", true);
		
	# Display Blank Option
	league_button.text = "Select League..."


func populate_team_grid(grid: GridContainer, tile: PackedScene, data: Array[Dictionary], data_text: String, data_icon_path: String, replace := true ) -> void:
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
		tile_scene.get_child(0).connect("pressed", Callable(self, "_on_team_tile_pressed").bind(row["id"]))
		grid.add_child(tile_scene)
		
		# Load Icon, if any, else ignore
		var icon = AssetManager.load_asset(row[data_icon_path], true);confed_button
		tile_scene.set_tile_and_icon(row["name"], icon)
		
		# Connect signal here
				
		# Set Metadata
		#tile_scene.metadata = row["id"];
		
	
	return

func _on_team_tile_pressed(team_id: int) -> void:
	selected_options["Team"] = team_id;

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
	
## Gender Filter Toggled
func _on_gender_selection_toggled(toggled_on: bool) -> void:
	# First, change text of button to reflect change
	gender_button.text = "Women" if toggled_on else "Men"
	
	# Now, we change the remaining hierachy of options
	option_selection_made("Gender", 1 if toggled_on else 0);


func _on_confirm_button_pressed() -> void:
	match selected_options["Phase"]:
		SelectionPhase.SELECT_PLAYER:
			var team_id = selected_options["Team"]
			if team_id == -1:
				print("Please select a team first.")
				return
			selected_options["UserTeam"] = team_id
			selected_options["Phase"] = SelectionPhase.SELECT_OPPONENT
			#print("User team confirmed:", team_id)
			var tile_scene = TEAM_TILE.instantiate();
			user_team_display.add_child(tile_scene)
			
			var data = DBManager.query_rows(SIMPLE_TEAM_QUERY.format({"team_id" = team_id}))
			
			# Load Icon, if any, else ignore
			var icon = AssetManager.load_asset(data[0]["logo_path"], false)
			tile_scene.set_tile_and_icon(data[0]["name"], icon)
			
			_update_phase_ui()

		SelectionPhase.SELECT_OPPONENT:
			var team_id = selected_options["Team"]
			if team_id == -1:
				print("Please select a team first.")
				return
			selected_options["OppTeam"] = team_id
			selected_options["Phase"] = SelectionPhase.READY
			print("Opponent team confirmed:", team_id)
			
			var tile_scene = TEAM_TILE.instantiate();
			opp_team_display.add_child(tile_scene)
			
			var data = DBManager.query_rows(SIMPLE_TEAM_QUERY.format({"team_id" = team_id}))
			
			# Load Icon, if any, else ignore
			var icon = AssetManager.load_asset(data[0]["logo_path"], false)
			tile_scene.set_tile_and_icon(data[0]["name"], icon)
			
			
			_update_phase_ui()

		SelectionPhase.READY:
			if selected_options["UserTeam"] == -1 or selected_options["OppTeam"] == -1:
				print("Both teams must be selected before starting.")
				return
			# TODO: Now we can switch scenes to Match or 
			# Team Management Scene Before Playing


func _on_team_type_selection_toggled(toggled_on: bool) -> void:
	# First, change text of button to reflect change
	teamtype_button.text = "National Teams" if toggled_on else "Club Teams"
	
	# Now, we change the remaining hierachy of options
	option_selection_made("TeamType", 1 if toggled_on else 0);





func _on_search_box_text_submitted(new_text: String) -> void:
	search_text = new_text;
	
	_load_teams()


func _on_reselect_button_pressed() -> void:
	match selected_options["Phase"]:
		SelectionPhase.SELECT_OPPONENT:
			# Go back to SELECT_PLAYER phase
			selected_options["Phase"] = SelectionPhase.SELECT_PLAYER
			selected_options["UserTeam"] = -1
			
			# Clear UI
			for child in user_team_display.get_children():
				child.queue_free()

			print("Returning to Player Team Selection Phase.")
			_update_phase_ui()

		SelectionPhase.READY:
			# Go back to SELECT_OPPONENT phase
			selected_options["Phase"] = SelectionPhase.SELECT_OPPONENT
			selected_options["OppTeam"] = -1

			# Clear opponent team UI
			for child in opp_team_display.get_children():
				child.queue_free()

			print("Returning to Opponent Selection Phase.")
			_update_phase_ui()

		_:
			print("Nothing to reselect at this phase.")
