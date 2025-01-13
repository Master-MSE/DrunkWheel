extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randi()%10 < 2:
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_y(0.1)
