extends Control
signal start

func _on_start_pressed() -> void:
	self.visible = false
	Game.game_state = Game.GameStates.PLAYING
	start.emit()

func _on_quit_pressed() -> void:
	get_tree().quit()
