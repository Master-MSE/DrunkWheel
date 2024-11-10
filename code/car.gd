extends VehicleBody3D

@export var vertical_obstacle_collision_impulse_strength: float = 1.0
@export var relative_obstacle_collision_impulse_strength: float = 1.0

const MAX_SPEED = 25.0
const MAX_ENGINE_FORCE = 800.0
const MAX_BRAKE_FORCE = 10.0
const MAX_STEERING_ANGLE = 0.6
const STEERING_SPEED = 0.05
const NORMAL_FRICTION = 5.0
const DRIFT_FRICTION_REDUCTION_BACK = 0.08
const DRIFT_FRICTION_REDUCTION_FRONT = 0.1
const DRIFT_SPEED_THRESHOLD = 20.0

var steering_angle = 0.0

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
	if(linear_velocity.length() < MAX_SPEED && engine_input != -1):
		$"wheel-back-left".engine_force = engine_input * MAX_ENGINE_FORCE
		$"wheel-back-right".engine_force = engine_input * MAX_ENGINE_FORCE
	else:
		$"wheel-back-left".engine_force = 0
		$"wheel-back-right".engine_force = 0
	if (engine_input == -1):
		brake = MAX_BRAKE_FORCE 
	else:
		brake = 0	

func align_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
	
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
	
	if ($"raycast-front".is_colliding() || $"raycast-back".is_colliding()):
		var nf = $"raycast-front".get_collision_normal() if $"raycast-front".is_colliding() else Vector3.UP
		var nr = $"raycast-back".get_collision_normal() if $"raycast-back".is_colliding() else Vector3.UP
		var n = ((nr + nf) / 2.0).normalized()
		var xform = align_y(global_transform, n)
		global_transform = global_transform.interpolate_with(xform, 0.1)
	
	#drift()
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
