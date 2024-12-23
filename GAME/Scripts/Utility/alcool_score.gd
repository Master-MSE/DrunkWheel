extends Node

var score_alcool : float

func _ready() -> void:
	reset()
func reset()-> void:
	score_alcool=0.0
func get_score()->float:
	return score_alcool
func add_score(value:float)->void:
	score_alcool+=value
