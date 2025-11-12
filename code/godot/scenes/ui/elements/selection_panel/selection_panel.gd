extends MarginContainer

@onready 
var SELECTION_GRID: GridContainer = %SelectionGrid

@onready
var TITLE: Label = %Title


var selected_tile: int = -1;

func set_title(title: String) -> void:
	TITLE.text = title;
	return

func 
	
