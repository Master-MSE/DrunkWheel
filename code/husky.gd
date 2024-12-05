extends CharacterBody3D

@onready var agent = $NavigationAgent3D
@onready var raycast = $RayCast3D

var max_speed = 12.0
var min_speed = 8.0

# Max position
var min_z = -50.0
var max_z = 50.0
var min_x = -75.0
var max_x = 75.0

var random_x = 0
var random_z = 0

var change_interval = 5.0
var time_since_change = 0.0
var random_movement_range = 5.0
var toggle = true
var dead = false
var dead_animation_played = false

func _physics_process(delta: float) -> void:
	if !dead:
		time_since_change += delta
			
		if time_since_change >= change_interval or agent.is_navigation_finished():
			get_random_direction()
			time_since_change = 0.0
			
		if raycast.is_colliding():
			if raycast.get_collider() is VehicleBody3D:
				dead = true
			else:
				get_random_direction()
			
			
		var current_location = global_transform.origin
		var next_location = agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * randf_range(min_speed, max_speed)
		
		$Husky/AnimationPlayer.play("Gallop")
		
		velocity = new_velocity
		look_at(agent.get_next_path_position())
		move_and_slide()
	elif dead_animation_played == false:
		$Husky/AnimationPlayer.queue("Death")
		dead_animation_played  = true
		

# Choose target
func update_target_location(target_location):
	agent.target_position = target_location
	
# Random target
func get_random_direction() -> void:
	# Generate a random direction
	# Always go to the opposite on axis z so it cross the road
	if random_x <= 0 :
		random_x = randf_range(min_x, max_x + random_x)
	else:
		random_x = randf_range(min_x + random_x, max_x)
		
	random_z = min_z if toggle else max_z
	toggle = !toggle

	agent.target_position = Vector3(random_x, 0, random_z)
