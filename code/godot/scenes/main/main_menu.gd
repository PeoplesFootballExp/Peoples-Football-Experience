extends Control

const PLAY_MATCH_SCENE: String = "res://scenes/ui/menus/team_selection/team_selection.tscn"


func _on_play_match_button_pressed() -> void:
	SceneManager.change_scene(PLAY_MATCH_SCENE)


func _on_exit_game_button_pressed() -> void:
	$ConfirmationDialog.visible = true

func _on_confirmation_dialog_confirmed() -> void:
	get_tree().quit();
	return

func _on_cancel_dialog_canceled() -> void:
	$ConfirmationDialog.visible = false
