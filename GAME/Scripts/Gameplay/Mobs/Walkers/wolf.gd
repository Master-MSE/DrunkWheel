extends CharacterBody3D

@onready var agent = $NavigationAgent3D
@onready var raycast = $RayCast3D

var max_speed = 12.0
var min_speed = 8.0

# Range
var range_z = 50.0
var range_x = 60.0

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
		
		$Wolf/AnimationPlayer.play("Gallop")
		
		velocity = new_velocity
		if(agent.get_next_path_position() != global_transform.origin):
			look_at(agent.get_next_path_position())
		move_and_slide()
	elif dead_animation_played == false:
		$Wolf/AnimationPlayer.queue("Death")
		dead_animation_played  = true
		

# Random target
func get_random_direction() -> void:
	var base_position = global_transform.origin
	
	random_x = base_position.x + range_x * randf_range(-1,1)
	
	random_z = base_position.z + (-range_z if toggle else range_z)
	toggle = !toggle
	
	agent.target_position = Vector3(random_x, base_position.y, random_z)
