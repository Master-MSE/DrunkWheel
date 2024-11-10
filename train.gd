extends CharacterBody3D


# Minimum speed of the mob in meters per second.
@export var speed = 25

func _physics_process(delta: float) -> void:
	move_and_slide()

# This function will be called from the Main scene.
func initialize():
	velocity = Vector3.FORWARD * speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
