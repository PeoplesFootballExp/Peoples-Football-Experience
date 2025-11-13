extends VBoxContainer
## Handles All UI Logic in the scene
##
## Handles Button Signals, SQLite Queries, and Team Selection Logic

# --------------------------------------
# Enums
# --------------------------------------
enum SelectionPhase { SELECT_PLAYER =0, SELECT_OPPONENT=1, READY=2}

# --------------------------------------
# Constants
# --------------------------------------

# Scenes
const MAIN_SCENE: String = "res://scenes/main/main_menu.tscn";
const TEAM_TILE: PackedScene = preload("res://scenes/ui/elements/selection_tile/selection_tile.tscn");

# Hierarchy Dictionary
const HIERARCHY: Dictionary[String, String] = {
	"Confed": "Terr",
	"Terr": "League",
	"TeamType": "League",
	"Gender": "League",
	"League": "Team",
	"Team": "Team"
}

# SQLite Queries
#region
## Query to get territories dependent on confederation selection 
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
		
## Query to get only continental confederations (UEFA, CONMEBOL, etc)
const CONFED_QUERY: String = "SELECT id, name, logo_path FROM Confederation WHERE Confederation.level = 1"

const ALL_TERR_QUERY: String = "WITH RECURSIVE level1_confed AS (
    SELECT
        t.id,
        t.name,
        t.logo_path,
        c.id AS confed_id,
        c.parent_id,
        c.level
    FROM Territory t
    JOIN Confederation c ON t.confed_id = c.id
    WHERE t.is_active = TRUE

    UNION ALL

    SELECT
        l1.id,
        l1.name,
        l1.logo_path,
        c.id AS confed_id,
        c.parent_id,
        c.level
    FROM level1_confed l1
    JOIN Confederation c ON l1.parent_id = c.id
    WHERE c.level >= 1
)
SELECT
    t.id,
    t.name,
    t.logo_path,
    l1.confed_id
FROM Territory t
JOIN level1_confed l1
    ON t.id = l1.id
WHERE l1.level = 1
;
"

const ALL_TEAM_QUERY: String = "WITH RECURSIVE team_confed_ancestry AS (
    -- Anchor Member: Start with all Active, Top-Level Teams from Active Territories
    SELECT
        TM.id,
        TM.name,
        TM.logo_path,
        TM.territory_id,
        TM.gender,
        TM.team_type,
        TR.confed_id AS starting_confed_id,
        C.id AS current_confed_id,
        C.parent_id,
        C.level
    FROM Team TM
    INNER JOIN Territory TR ON TM.territory_id = TR.id
    INNER JOIN Confederation C ON TR.confed_id = C.id
    WHERE 
        TM.is_active = 1            -- Only active teams
        AND TM.parent_id IS NULL    -- Only top-level teams (no youth/reserves)
        AND TR.is_active = 1        -- Only teams from active territories

    UNION ALL

    -- Recursive Member: Trace the hierarchy UP to the parent Confederation
    SELECT
        TCA.id,
        TCA.name,
        TCA.logo_path,
        TCA.territory_id,
        TCA.gender,
        TCA.team_type,
        TCA.starting_confed_id,
        C.id AS current_confed_id,
        C.parent_id,
        C.level
    FROM team_confed_ancestry TCA
    INNER JOIN Confederation C ON TCA.parent_id = C.id
    -- Stop recursion when we reach the World Confed (Level 0, which has parent_id IS NULL)
    WHERE TCA.parent_id IS NOT NULL 
)
SELECT
    TCA.id,
    TCA.name,
    TCA.logo_path,
    TCA.territory_id,
    TCA.gender,
    TCA.team_type,
    TCA.current_confed_id AS confed_id
FROM team_confed_ancestry TCA
-- Only select the row where the recursion reached the Level 1 Confed
WHERE TCA.level = 1 
ORDER BY TCA.id;"

## Query to get tournaments dependent on filter options (Confed, Terr, TeamType, and Gender)
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

## Query to get Teams dependent on all the filter options (Confed, Terr, Tournament, Gender, TeamType, and Search Text)
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

## Smple Query to get Team by Team ID
const SIMPLE_TEAM_QUERY: String = "SELECT * FROM Team WHERE id = {team_id}"

#endregion

# --------------------------------------
# Private Variables
# --------------------------------------
## The current text the user inputs into the search box, used to query teams (overriding other filter options)
var _search_text: String = "";

## Selection Options: The current selections of all filters and teams selected
var _selected_options: Dictionary[String, int] = {
	"Confed": 1, # ID of 1 is of the world
	"Terr": -1, # -1 means none selected
	"Gender": 0, # Men is 0, Women is 1 
	"TeamType": 0, # Club Team is 0, National team is 1
	"League": -1, # -1 means no league selected
	"Phase": SelectionPhase.SELECT_PLAYER, 
	"Team": -1,
	"UserTeam": - 1, # -1 means none selected
	"OppTeam": -1, # -1 means none selected
}


# --------------------------------------
# @onready variables
# --------------------------------------

#region OnReady Variables
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
#endregion


# --------------------------------------
# Overwritten built in virtual methods
# --------------------------------------

func _ready() -> void:
	# Create a new save, only for testing
	# TODO: Move this to save file selection and creation scene
	#SaveManager.create_new_save(1, "Testing");
	
	# Activate the current save file, for now just use slot 1
	# TODO: Move to a save file selection scene
	SaveManager.activate_save(1);
	
	# Initiate the DB Connection
	DBManager.init_db(SaveManager.get_active_db_path());
	
	
	# Populate the confed and terr option buttons with all options
	_load_confeds()
	_load_terrs()
	#_load_leagues() #National teams don't have leagues
	_load_teams()


func _prepare_grid() -> void:
	pass
	

# --------------------------------------
# Hierarchy Function, Recursively walks down the hierarchy, updating 
# --------------------------------------

## Recursive Hierarchy handler: Recursivly sends down chain of selected options 
func option_selection_made(option_type: String, new_id: int) -> void:
	# Update the selected value
	_selected_options[option_type] = new_id
	
	# Carry out options resets
	if HIERARCHY.has(option_type):
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

## Confirm Button Helper Function: Updates Some UI Text based on Selection Phase
func _update_phase_ui() -> void:
	match _selected_options["Phase"]:
		SelectionPhase.SELECT_PLAYER:
			confirm_button.text = "Confirm User Team"
			phase_label.text = "Select your team"
		SelectionPhase.SELECT_OPPONENT:
			confirm_button.text = "Confirm Opponent Team"
			phase_label.text = "Select opponent team"
		SelectionPhase.READY:
			confirm_button.text = "Start Match"
			phase_label.text = "Ready to play!"

# --------------------------------------
# Populating UI Containers
# --------------------------------------

## Load Confederation Option Button, done once in the _ready() function
func _load_confeds() -> void:
	var confeds: Array[Dictionary] = DBManager.query_rows(CONFED_QUERY)
	
	# Populate it
	Utils.populate_option_button(confed_button, confeds, "name", "logo_path", true, true)
	
	# Display Blank Option
	confed_button.text = "Select Confederation..."
	
	return


## Load Territories Option Button, dependent on Selected Options: Confederation
func _load_terrs() -> void:
	# Else, filter territories by confed choosen (opposite so we know which to make invisible)
	var terrs: Array[Dictionary] = DBManager.query_rows(TERRITORY_QUERY.format([str(_selected_options["Confed"])]));

	# Fill Option Button
	Utils.populate_option_button(terr_button, terrs, "name", "logo_path", true, true)
	
	# Display Blank Option
	terr_button.text = "Select Territory..."

## Load League Option Button, dependent on Selected Options: Confederation, Territory, TeamType, and Gender
func _load_leagues() -> void:
	# Get All Tournaments
	var tours: Array[Dictionary] = DBManager.query_rows(TOUR_QUERY.format({
		"confed_id": _selected_options["Confed"], 
		"gender": str(_selected_options["Gender"]),
		"team_type": str(_selected_options["TeamType"]),
		"terr_id": _selected_options["Terr"] if _selected_options["Terr"] > 0 else "NULL",
	}))
	
	# Fill Option Button
	Utils.populate_option_button(league_button, tours, "name", "logo_path")
		
	# Display Blank Option
	league_button.text = "Select League..."

## Load Team GridContainer, depending on Selected Options: Confederation, Territory, TeamType, Gender, League, and SearchText
func _load_teams() -> void:
	# Get All Teams
	var teams: Array[Dictionary] = DBManager.query_rows(TEAM_QUERY.format({
		"confed_id": _selected_options["Confed"], 
		"gender": str(_selected_options["Gender"]),
		"team_type": str(_selected_options["TeamType"]),
		"terr_id": _selected_options["Terr"] if _selected_options["Terr"] > 0 else "NULL",
		"search_text": "'{text}'".format({"text": _search_text}) if _search_text.length() > 0  else "NULL"
		
	}))
	
	# Fill Option Button
	populate_team_grid(team_grid, TEAM_TILE, teams, "name", "logo_path", true);
		
	# Display Blank Option
	league_button.text = "Select League..."

## Load Team GirdContainer Helper Function, simply instantciates the Team Selection Tile and connects signals needed
func populate_team_grid(grid: GridContainer, tile: PackedScene, data: Array[Dictionary], data_text: String, data_icon_path: String, replace := true ) -> void:
	# Validate Field Strings
	if data_text == "" or data_icon_path == "":
		return
		
	# Clear Grid Container if desired
	if replace:
		for child in grid.get_children():
			child.queue_free()
	
	# Iterate through data, each row being a dictionary
	for row in data:
		## Add Team Selection Tile to GridContainer
		var tile_scene = tile.instantiate();
		tile_scene.get_child(0).connect("pressed", Callable(self, "_on_team_tile_pressed").bind(row["id"]))
		grid.add_child(tile_scene)
		
		# Load Icon, if any, else ignore
		var icon = AssetManager.load_asset(row[data_icon_path], true);confed_button
		if icon:
			tile_scene.set_tile_and_icon(row["name"], icon)


# --------------------------------------
# Signal Handlers
# --------------------------------------
## Handles Team Tile being pressed: Simply sets team_id for Selected Options: Team
func _on_team_tile_pressed(team_id: int) -> void:
	_selected_options["Team"] = team_id;

## Handles Back Button being pressed: Changes scene back to Main Menu
func _on_back_button_pressed() -> void:
	SceneManager.change_scene(MAIN_SCENE);
	
## Handles Confederation Option being selected: Sends Change Down Hierarchy (Confed -> Terr -> League -> Team)  
func _on_confed_selection_item_selected(index: int) -> void:
	# Get Metadata of selection
	var confed_id: int = confed_button.get_item_metadata(index);
	
	# Get ID of Confed choosen, reset Territory Option Button
	option_selection_made("Confed", confed_id);

## Handles Territory Option being selected: Sends Change Down Hierarchy (Terr -> League -> Team) 
func _on_territory_selection_item_selected(index: int) -> void:
	# Get Metadata of selection
	var terr_id: int= terr_button.get_item_metadata(index);
	
	# Get ID of Confed choosen, reset Tournament Option Button
	option_selection_made("Terr", terr_id)

## Handles TeamType button being toggled: Sends Change Down Hierarchy (TeamType -> League -> Team) 
func _on_team_type_selection_toggled(toggled_on: bool) -> void:
	# First, change text of button to reflect change
	teamtype_button.text = "National Teams" if toggled_on else "Club Teams"
	
	# Now, we change the remaining hierachy of options
	option_selection_made("TeamType", 1 if toggled_on else 0);

## Handles Gender button being toggled: Sends Change Down Hierarchy (Gender -> League -> Team) 
func _on_gender_selection_toggled(toggled_on: bool) -> void:
	# First, change text of button to reflect change
	gender_button.text = "Women" if toggled_on else "Men"
	
	# Now, we change the remaining hierachy of options
	option_selection_made("Gender", 1 if toggled_on else 0);

## Handles Search Box Text Submitted: Overrides all Selected Options, and queries entire team database 
func _on_search_box_text_submitted(new_text: String) -> void:
	_search_text = new_text;
	
	_load_teams()

# --------------------------------------
# Confirm and Reselect Buttons Signal Handlers
# --------------------------------------
#region
## Handles Confirm Button being pressed: Locks in User and Opponent Team selection or changes scene 
## when both are done
func _on_confirm_button_pressed() -> void:
	match _selected_options["Phase"]:
		SelectionPhase.SELECT_PLAYER:
			var team_id = _selected_options["Team"]
			if team_id == -1:
				print("Please select a team first.")
				return
			_selected_options["UserTeam"] = team_id
			_selected_options["Phase"] = SelectionPhase.SELECT_OPPONENT
			#print("User team confirmed:", team_id)
			var tile_scene = TEAM_TILE.instantiate();
			user_team_display.add_child(tile_scene)
			
			var data = DBManager.query_rows(SIMPLE_TEAM_QUERY.format({"team_id" = team_id}))
			
			# Load Icon, if any, else ignore
			var icon = AssetManager.load_asset(data[0]["logo_path"], false)
			tile_scene.set_tile_and_icon(data[0]["name"], icon)
			
			_update_phase_ui()

		SelectionPhase.SELECT_OPPONENT:
			var team_id = _selected_options["Team"]
			if team_id == -1:
				print("Please select a team first.")
				return
			_selected_options["OppTeam"] = team_id
			_selected_options["Phase"] = SelectionPhase.READY
			print("Opponent team confirmed:", team_id)
			
			var tile_scene = TEAM_TILE.instantiate();
			opp_team_display.add_child(tile_scene)
			
			var data = DBManager.query_rows(SIMPLE_TEAM_QUERY.format({"team_id" = team_id}))
			
			# Load Icon, if any, else ignore
			var icon = AssetManager.load_asset(data[0]["logo_path"], false)
			tile_scene.set_tile_and_icon(data[0]["name"], icon)
			
			
			_update_phase_ui()

		SelectionPhase.READY:
			if _selected_options["UserTeam"] == -1 or _selected_options["OppTeam"] == -1:
				print("Both teams must be selected before starting.")
				return
			# TODO: Now we can switch scenes to Match or 
			# Team Management Scene Before Playing


## Handles Reselect Button Being Pressed: Resets to the previous selection phrase, unlocking User 
## and Opponent Team Selection
func _on_reselect_button_pressed() -> void:
	match _selected_options["Phase"]:
		SelectionPhase.SELECT_OPPONENT:
			# Go back to SELECT_PLAYER phase
			_selected_options["Phase"] = SelectionPhase.SELECT_PLAYER
			_selected_options["UserTeam"] = -1
			
			# Clear UI
			for child in user_team_display.get_children():
				child.queue_free()

			print("Returning to Player Team Selection Phase.")
			_update_phase_ui()

		SelectionPhase.READY:
			# Go back to SELECT_OPPONENT phase
			_selected_options["Phase"] = SelectionPhase.SELECT_OPPONENT
			_selected_options["OppTeam"] = -1

			# Clear opponent team UI
			for child in opp_team_display.get_children():
				child.queue_free()

			print("Returning to Opponent Selection Phase.")
			_update_phase_ui()

		_:
			print("Nothing to reselect at this phase.")
#endregion
