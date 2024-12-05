extends Node

signal object_hit

var collision_counter : int = 0
var total_price : float = 0
var registered_collisions : Dictionary


func new_collision(name: String, value: float) -> void:
	
	if registered_collisions.has(name):
		registered_collisions[name] += 1
	else:
		registered_collisions[name] = 1
	
	total_price+=value
	
	collision_counter+=1
	object_hit.emit()

func get_collision_counter() -> int:
	return collision_counter

func get_total_price() -> float:
	return total_price
