extends Control

@onready
var ICON: TextureRect = %Icon;
@onready 
var TEXT: Label = %Text;
@onready
var SUBTEXT: Label = %SubText

@onready
var ATTACK_AVERAGE: Label = %AttackAverage
@onready
var MID_AVERAGE: Label = %MidAverage
@onready
var DEF_AVERAGE: Label = %DefenseAverage

@onready
var OUTFIELD_SECTIONS: HBoxContainer = $TeamButton/MarginContainer/VBox/OutfieldSection

@onready 
var SECTION_AVERAGES: HBoxContainer = $TeamButton/MarginContainer/VBox/SectionAverages



var grid_index: int = -1;



func set_tile(input_text: String, input_texture: Texture, input_subtext:= "") -> void:
	# We simply put these images and text into the Tile
	ICON.texture = input_texture;
	TEXT.text = input_text;
	SUBTEXT.text = input_subtext;
	
	
func set_averages(attack: int, mid: int, defense: int) -> void:
	# First validate values input
	attack = clamp(attack, 1, 99);
	mid = clamp(mid, 1, 99);
	defense = clamp(defense, 1, 99);
	
	# Now, we set the text as the values
	ATTACK_AVERAGE.text = str(attack);
	MID_AVERAGE.text = str(mid);
	DEF_AVERAGE.text = str(defense);

	# Now, we make both the outfield sections and section averages visible
	OUTFIELD_SECTIONS.visible = true;
	SECTION_AVERAGES.visible = true;
	
	return
	

	
