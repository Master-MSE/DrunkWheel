extends RigidBody3D

@onready var spotlight: SpotLight3D = $SpotLight3D2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func _on_sleeping_state_changed() -> void:
	if spotlight != null:
		spotlight.queue_free()
