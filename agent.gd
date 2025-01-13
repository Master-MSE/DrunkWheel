extends CharacterBody3D

@onready var agent = $NavigationAgent3D
@onready var raycast = $RayCast3D

var max_speed = 12.0
var min_speed = 8.0

var min_z = 20.0
var max_z = -20.0
var min_x = 80.0
var max_x = 0.0

var change_interval = 5.0
var time_since_change = 0.0
var wait_interval = 1.0
var time_since_stop = 0.0
var random_movement_range = 5.0
var toggle = true

func _physics_process(delta: float) -> void:
	time_since_change += delta
	if time_since_change >= change_interval or agent.is_navigation_finished():
		time_since_stop += delta

	if time_since_stop >= wait_interval:
		get_random_direction()
		time_since_change = 0.0
		time_since_stop = 0.0
		
	if raycast.is_colliding():
		get_random_direction()
		
	if time_since_stop <= 0:
		var current_location = global_transform.origin
		var next_location = agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * randf_range(min_speed, max_speed)
		
		velocity = new_velocity
		look_at(agent.get_next_path_position())
		move_and_slide()
	
# Choose target
func update_target_location(target_location):
	agent.target_position = target_location
	
# Random target
func get_random_direction() -> void:
	# Generate a random direction
	# Always go to the opposite on axis z so it cross the road
	var random_x = randf_range(min_x, max_x)
	var random_z = min_z if toggle else max_z
	toggle = !toggle
	
	agent.target_position = Vector3(random_x, 0, random_z)
