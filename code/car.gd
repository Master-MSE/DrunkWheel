extends VehicleBody3D

@export var vertical_obstacle_collision_impulse_strength: float = 1.0
@export var relative_obstacle_collision_impulse_strength: float = 1.0

const MAX_SPEED = 15.0
const MAX_ENGINE_FORCE = 2000.0
const MAX_BRAKE_FORCE = 10.0
const MAX_STEERING_ANGLE = 0.7
const STEERING_SPEED = 0.05

var steering_angle = 0.0
		
func steering(steering_input):
	if(steering_input != 0):
		steering_angle += ( STEERING_SPEED * steering_input)
		
		if (steering_angle < MAX_STEERING_ANGLE && steering_angle > -MAX_STEERING_ANGLE):
			$"wheel-front-left".steering = steering_angle
			$"wheel-front-right".steering = steering_angle
		else:
			steering_angle = MAX_STEERING_ANGLE * steering_input
			$"wheel-front-left".steering = steering_angle
			$"wheel-front-right".steering = steering_angle
			
	else:
		steering_angle = 0
		$"wheel-front-left".steering = steering_angle
		$"wheel-front-right".steering = steering_angle
		
func engine(engine_input):
	if(linear_velocity.length() < MAX_SPEED):
		$"wheel-back-left".engine_force = engine_input * MAX_ENGINE_FORCE
		$"wheel-back-right".engine_force = engine_input * MAX_ENGINE_FORCE
	else:
		$"wheel-back-left".engine_force = 0
		$"wheel-back-right".engine_force = 0
	if (engine_input == -1):
		brake = MAX_BRAKE_FORCE 
	else:
		brake = 0	

	
func _physics_process(delta):
	var steering_input = 0.0
	var engine_input = 0.0

	if Input.is_action_pressed("right"):
		steering_input -= 1
	if Input.is_action_pressed("left"):
		steering_input += 1
	
	if Input.is_action_pressed("forward"):
		engine_input += 1
	if Input.is_action_pressed("reverse"):
		engine_input -= 1
		$"light-back-left".visible = true
		$"light-back-right".visible = true
	else:
		$"light-back-left".visible = false
		$"light-back-right".visible = false
	
	steering(steering_input)
	engine(engine_input)
		
	


func _on_body_entered(body: Node) -> void:
	print("Body Entered")
	if body is RigidBody3D:
		if body.collision_layer == 2:
			body.apply_impulse(linear_velocity + 
			(Vector3.UP * vertical_obstacle_collision_impulse_strength) + 
			((body.position - position) * relative_obstacle_collision_impulse_strength))
			
			print(str(linear_velocity))
