extends Node

signal shoot(type)


# Called when the node enters the scene tree for the first time.
func emite_shoot(type) -> void:
	shoot.emit(type)
