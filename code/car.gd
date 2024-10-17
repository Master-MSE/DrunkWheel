extends VehicleBody3D

const MAX_SPEED = 25.0
const MAX_ENGINE_FORCE = 500.0
const MAX_BRAKE_FORCE = 10.0
const MAX_STEERING_ANGLE = 0.6
const NORMAL_FRICTION = 5.0
const DRIFT_FRICTION_REDUCTION_BACK = 0.08
const DRIFT_FRICTION_REDUCTION_FRONT = 0.1
const DRIFT_SPEED_THRESHOLD = 20.0

var steering_angle = 0.0
var engine = 0.0

func drift():
	var speed = linear_velocity.length()
	var is_drifting = speed > DRIFT_SPEED_THRESHOLD
	if is_drifting:
		$"wheel-back-left".wheel_friction_slip = NORMAL_FRICTION * DRIFT_FRICTION_REDUCTION_BACK
		$"wheel-back-right".wheel_friction_slip = NORMAL_FRICTION * DRIFT_FRICTION_REDUCTION_BACK
		$"wheel-front-left".wheel_friction_slip = NORMAL_FRICTION * DRIFT_FRICTION_REDUCTION_FRONT
		$"wheel-front-right".wheel_friction_slip = NORMAL_FRICTION * DRIFT_FRICTION_REDUCTION_FRONT
	else:
		pass
		$"wheel-back-left".wheel_friction_slip = NORMAL_FRICTION
		$"wheel-back-right".wheel_friction_slip = NORMAL_FRICTION
		$"wheel-front-left".wheel_friction_slip = NORMAL_FRICTION
		$"wheel-front-right".wheel_friction_slip = NORMAL_FRICTION
		
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

	drift()
	
	$"wheel-front-left".steering = lerp(steering_angle, steering_input * MAX_STEERING_ANGLE, 0.3)
	$"wheel-front-right".steering = lerp(steering_angle, steering_input * MAX_STEERING_ANGLE, 0.3)

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
		
	
