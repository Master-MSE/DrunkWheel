extends Node3D

@onready var train: CharacterBody3D = $Train

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	train.initialize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
