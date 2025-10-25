extends FoldableContainer


var SELECTION_TILE: PackedScene = preload("res://scenes/ui/elements/selection_tile/selection_tile.tscn");

@onready
var GRID_CONTAINER: GridContainer = $GridContainer

func _on_folding_changed(is_folded: bool) -> void:
	if folded == false and GRID_CONTAINER.get_child_count() == 0:
		for i in range(12):
			var tile: Control = SELECTION_TILE.instantiate();
			GRID_CONTAINER.add_child(tile);
			
