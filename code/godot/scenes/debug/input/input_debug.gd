extends Node

var last_gm: GameCommand = null
func _process(delta):
	ImGui.Begin("My Window")
	if last_gm:
		ImGui.Text(str(last_gm.is_double_tap))
	ImGui.End()

func _ready() -> void:
	$Control.command_issued.connect(_command_issued)
	
	InputRouter.active_human_controller = $Control
	InputRouter.active_ui_root = $"."
	
func _command_issued(gm: GameCommand) -> void:
	ImGui.Begin("My Window")
	ImGui.Text(str(gm.is_finesse_shot()))
	ImGui.End()
