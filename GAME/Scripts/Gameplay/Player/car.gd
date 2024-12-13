extends VehicleBody3D
class_name Car

signal alcohol_collected
signal object_hit
signal end_reached
static var hitted_objects: Array = []

@export var vertical_obstacle_collision_impulse_strength: float = 1
@export var relative_obstacle_collision_impulse_strength: float = 1

const MAX_SPEED = 20.0
const MAX_ENGINE_FORCE = 2000.0
const MAX_BRAKE_FORCE = 35.0
const MAX_STEERING_ANGLE = 0.7
const STEERING_SPEED = 0.04
const DELAY_DELAY_START = 3.0
const DELAY_MAX = 0.5
const DELAY_FACTOR = DELAY_MAX/(10.0-DELAY_DELAY_START)

var steering_angle = 0.0
var delay_duration =0.0
var parent
var input_queue = []
var time = 0.0
var max_delay=2.0
var crash_animation = preload("res://GAME/Scenes/Animations/animation_crash.tscn")
var dink_animation = preload("res://GAME/Scenes/Animations/animation_drink.tscn")

func steering(steering_input):
	# If there's steering input, adjust the steering angle
	if steering_input != 0:
		steering_angle += (STEERING_SPEED * steering_input)
		
		# Clamp the steering angle within the max limits using clampf
		steering_angle = clampf(steering_angle, - MAX_STEERING_ANGLE, MAX_STEERING_ANGLE)

		# Apply the clamped steering angle to the wheels
		$"wheel-front-left".steering = steering_angle
		$"wheel-front-right".steering = steering_angle

	# Reset steering angle if no input
	else:
		steering_angle = 0
		$"wheel-front-left".steering = steering_angle
		$"wheel-front-right".steering = steering_angle
		
func engine(action):
	# Calculate the vehicle's local speed along each axis
	var b = transform.basis
	var v_len = linear_velocity.length()
	var v_nor = linear_velocity.normalized()

	var speed : Vector3
	speed.x = b.x.dot(v_nor) * v_len
	speed.y = b.y.dot(v_nor) * v_len
	speed.z = b.z.dot(v_nor) * v_len

	# Forward input
	if  action.has("forward"):
		if speed.x < 0:
			brake = MAX_BRAKE_FORCE  # Apply brake if moving backward
		else:
			brake = 0
			# Apply proportional engine force based on speed
			if speed.x >= (MAX_SPEED / 4) and speed.x < MAX_SPEED:
				engine_force = clampf((speed.x / MAX_SPEED) * 2 * MAX_ENGINE_FORCE, 0.0, MAX_ENGINE_FORCE)
			elif speed.x < (MAX_SPEED / 4):
				engine_force = MAX_ENGINE_FORCE * 3
			else:
				engine_force = 0  # No extra force if at max speed

	# Reverse input
	elif  action.has("reverse"):
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
	time+=delta
	delay_duration=clamp((parent.tauxalcool-DELAY_DELAY_START)*DELAY_FACTOR, 0.0, DELAY_MAX)
	colect_input(time)
	if Game.game_state != Game.GameStates.PLAYING:
		brake = MAX_BRAKE_FORCE
		return
	applie_input()
	

func _ready() -> void:
	contact_monitor = true
	set_max_contacts_reported(9999999)
	parent=get_parent().get_parent()

func _on_body_entered(body: Node) -> void:
	if body.collision_layer == 2:
		if body is RigidBody3D and body.freeze == true:
			hitted_objects.append(body.name)
			body.freeze = false
			body.apply_impulse((linear_velocity*relative_obstacle_collision_impulse_strength) + (Vector3.UP * vertical_obstacle_collision_impulse_strength))
			spawn_crash_effect()
	
	elif body.collision_layer == 4:
		body.queue_free()
		alcohol_collected.emit()
		spawn_drink_effect()
	
	elif body.collision_layer == 8:
		end_reached.emit()
		print("The End !")
			
func colect_input(time)->void:
	var action=[]
	if Input.is_action_pressed("left"):
		action.append("left")
	if Input.is_action_pressed("right"):
		action.append("right")
	if Input.is_action_pressed("forward"):
		action.append("forward")
	if Input.is_action_pressed("reverse"):
		action.append("reverse")
	if Input.is_action_just_pressed("alcool_drink"):
		alcohol_collected.emit()
	input_queue.append([action,time])
		
func applie_input()->void:
	var action = ["null"]
	var delete = 0
	for inpute in input_queue:
		if inpute[1]+delay_duration>time:
			break
		else:
			action=inpute[0]
			if inpute[1]<time-max_delay:
				delete+=1;
	for i in range(delete):
		input_queue.remove_at(0)
				
	var steering_input = 0.0

	if action.has("right"):
		steering_input -= 1
	if  action.has("left"):
		steering_input += 1
		
	# Set on the rear light when braking
	if  action.has("reverse"):
		$"light-back-left".visible = true
		$"light-back-right".visible = true
	else:
		$"light-back-left".visible = false
		$"light-back-right".visible = false
	
	steering(steering_input)
	engine(action)
			
func spawn_crash_effect():
	# add effect
	var effect = crash_animation.instantiate()
	add_child(effect)  

	# Calcule rotation
	var direction_avant = transform.basis.x  

	var avant_position = global_transform.origin + direction_avant * 2.5
	avant_position.y+=2.0
	effect.global_transform.origin = avant_position  
	effect.rotation_degrees = Vector3(-20.0,180.0,0.0)
	
func spawn_drink_effect():
	# add effect
	var effect = dink_animation.instantiate()
	add_child(effect)  

	# Calcule rotation
	var direction_avant = transform.basis.x  

	var avant_position = global_transform.origin + direction_avant * 2.5
	avant_position.y+=2.0
	effect.global_transform.origin = avant_position  
	effect.rotation_degrees = Vector3(-20.0,180,0.0)
	 
