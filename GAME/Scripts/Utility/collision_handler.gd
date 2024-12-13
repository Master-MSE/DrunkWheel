extends Node

signal object_hit

var collision_counter : int = 0
var registered_collisions : Dictionary
var collisions_prices : Dictionary

func new_collision(name: String, value: float) -> void:
	
	if registered_collisions.has(name):
		registered_collisions[name] += 1
		collisions_prices[name] += value
	else:
		registered_collisions[name] = 1
		collisions_prices[name] = value
	
	collision_counter+=1
	object_hit.emit()

func get_collision_counter() -> int:
	return collision_counter

func get_registered_collisions() -> Dictionary:
	return registered_collisions
	
func get_collision_prices() -> Dictionary:
	return collisions_prices
