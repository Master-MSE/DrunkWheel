extends VehicleBody3D

const MAX_ENGINE_FORCE = 200.0
const MAX_BRAKE_FORCE = 10.0
const MAX_STEERING_ANGLE = 0.3

var steering_angle = 0.0
var engine

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

	$"wheel-front-left".steering = lerp(steering_angle, steering_input * MAX_STEERING_ANGLE, 0.3)
	$"wheel-front-right".steering = lerp(steering_angle, steering_input * MAX_STEERING_ANGLE, 0.3)
	$"wheel-back-left".engine_force = engine_input * MAX_ENGINE_FORCE
	$"wheel-back-right".engine_force = engine_input * MAX_ENGINE_FORCE
	
	if (engine_input == -1):
		brake = MAX_BRAKE_FORCE 
	else:
		brake = 0	
	
