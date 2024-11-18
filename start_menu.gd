extends Control

func _on_start_pressed() -> void:
	self.visible = false
	Game.game_state = Game.GameStates.PLAYING

func _on_quit_pressed() -> void:
	get_tree().quit()
