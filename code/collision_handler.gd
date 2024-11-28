extends Node

signal object_hit

var collision_counter : int = 0
var registered_collisions : Dictionary


func new_collision(name: String, value: float) -> void:
	
	if registered_collisions.has(name):
		registered_collisions[name] += 1
	else:
		registered_collisions[name] = 1
	
	collision_counter+=1
	object_hit.emit()

func get_collision_counter() -> int:
	return collision_counter
