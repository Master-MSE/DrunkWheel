extends VehicleBody3D

@export var vertical_obstacle_collision_impulse_strength: float = 1.0
@export var relative_obstacle_collision_impulse_strength: float = 1.0

const MAX_SPEED = 10.0
const MAX_ENGINE_FORCE = 2000.0
const MAX_BRAKE_FORCE = 35.0
const MAX_STEERING_ANGLE = 0.7
const STEERING_SPEED = 0.04

var steering_angle = 0.0

func steering(steering_input):
	# If there's steering input, adjust the steering angle
	if steering_input != 0:
		steering_angle += (STEERING_SPEED * steering_input)
		
		# Clamp the steering angle within the max limits using clampf
		steering_angle = clampf(steering_angle, -MAX_STEERING_ANGLE, MAX_STEERING_ANGLE)

		# Apply the clamped steering angle to the wheels
		$"wheel-front-left".steering = steering_angle
		$"wheel-front-right".steering = steering_angle

	# Reset steering angle if no input
	else:
		steering_angle = 0
		$"wheel-front-left".steering = steering_angle
		$"wheel-front-right".steering = steering_angle

func engine():
	# Calculate the vehicle's local speed along each axis
	var b = transform.basis
	var v_len = linear_velocity.length()
	var v_nor = linear_velocity.normalized()

	var speed : Vector3
	speed.x = b.x.dot(v_nor) * v_len
	speed.y = b.y.dot(v_nor) * v_len
	speed.z = b.z.dot(v_nor) * v_len

	# Forward input
	if Input.is_action_pressed("forward"):
		if speed.x < 0:
			brake = MAX_BRAKE_FORCE  # Apply brake if moving backward
		else:
			brake = 0
			# Apply proportional engine force based on speed
			if speed.x >= (MAX_SPEED / 5) and speed.x < MAX_SPEED:
				engine_force = clampf((speed.x / MAX_SPEED) * 2 * MAX_ENGINE_FORCE, 0.0, MAX_ENGINE_FORCE)
			elif speed.x < (MAX_SPEED / 5):
				engine_force = MAX_ENGINE_FORCE * 2
			else:
				engine_force = 0  # No extra force if at max speed

	# Reverse input
	elif Input.is_action_pressed("reverse"):
		if speed.x > 0:
			brake = MAX_BRAKE_FORCE  # Apply brake if moving forward
		else:
			brake = 0
			# Apply reverse force based on speed
			if speed.x <= -(MAX_SPEED / 5) and speed.x > -MAX_SPEED:
				engine_force = -MAX_ENGINE_FORCE
			elif speed.x > -(MAX_SPEED / 5):
				engine_force = -MAX_ENGINE_FORCE * 2
			else:
				engine_force = 0  # No extra force if at max reverse speed

	# No input: set engine force to zero
	else:
		engine_force = 0

func _physics_process(delta):
	var steering_input = 0.0

	if Input.is_action_pressed("right"):
		steering_input -= 1
	if Input.is_action_pressed("left"):
		steering_input += 1
		
	# Set on the rear light when braking
	if Input.is_action_pressed("reverse"):
		$"light-back-left".visible = true
		$"light-back-right".visible = true
	else:
		$"light-back-left".visible = false
		$"light-back-right".visible = false
	
	steering(steering_input)
	engine()

func _on_body_entered(body: Node) -> void:
	print("Body Entered")
	if body is RigidBody3D:
		if body.collision_layer == 2:
			body.apply_impulse(linear_velocity + 
			(Vector3.UP * vertical_obstacle_collision_impulse_strength) + 
			((body.position - position) * relative_obstacle_collision_impulse_strength))
			
			print(str(linear_velocity))
