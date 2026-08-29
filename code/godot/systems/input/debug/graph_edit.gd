extends GraphEdit

func ready() -> void:
	connect("created_interpreter", _new_interpreter_created, 0)
	
	
func _new_interpreter_created(device_id: int) -> void:
	# Create a new node to visualize new interpreter
	var new_node: GraphNode = GraphNode.new()
	
	$".".add_child(new_node)
	
	
	
