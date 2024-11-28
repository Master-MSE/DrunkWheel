extends Node
class_name CollisionHandler

var collision_counter : int = 0

func new_collision() -> void:
	collision_counter+=1

func get_collision_counter() -> int:
	return collision_counter
