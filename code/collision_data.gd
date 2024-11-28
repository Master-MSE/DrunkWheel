extends Node

@export var object_name: String
@export var object_value: float

var destroyed : bool = false

func _on_sleeping_state_changed() -> void:
	if not destroyed:
		destroyed = true
		CollisionHandler.new_collision(object_name, object_value)
