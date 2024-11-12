extends StaticBody3D

var speed = randf_range(0.1, 0.05)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotate_z(randf_range(0.0, 6.2))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_z(speed)
