extends Node

enum ActionType {
	NONE,
	SHOOT,
	PASS,
	THROUGH_BALL,
	KNOCK_ON,
	TM_RUN,
	TM_SHORT,
	TM_PUSH,
	SPRINT,
	MOVE,
	SKILL_MOVE,
}


func _ready() -> void:
	$Control.command_issued.connect(_command_issued)
	
	var controller_node: Control = get_node("Control");
	InputRouter.register_input_interpreter(0, controller_node)
	
func _command_issued(gm: GameCommand) -> void:
	print(ActionType.keys()[gm.action])
