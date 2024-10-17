extends VehicleBody3D

############################################################
# behaviour values

var MAX_ENGINE_FORCE = 1000.0
var MAX_BRAKE_FORCE = 5.0
var MAX_STEER_ANGLE = 0.4

var steer_speed = 5.0

var steer_target = 0.0
var steer_angle = 0.0

############################################################
# Input
var steering_mult = -1.0
var throttle_mult = 1.0
var brake_mult = 1.0

func _ready():
	pass

func _physics_process(delta):
	var steer_val = steering_mult * Input.get_axis("right", "left")
	var throttle_val = throttle_mult * Input.get_axis("reverse", "forward")
	var brake_val = brake_mult * Input.get_axis("reverse", "forward")
	
	if Input.is_action_pressed("forward"):
		throttle_val = 1.0
	if Input.is_action_pressed("reverse"):
		throttle_val = -1.0
	if Input.is_action_pressed("reverse"):
		brake_val = 1.0
	if Input.is_action_pressed("left"):
		steer_val = 1.0
	if Input.is_action_pressed("right"):
		steer_val = -1.0
	
	engine_force = throttle_val * MAX_ENGINE_FORCE
	brake = brake_val * MAX_BRAKE_FORCE
	
	steer_target = steer_val * MAX_STEER_ANGLE
	if (steer_target < steer_angle):
		steer_angle -= steer_speed * delta
		if (steer_target > steer_angle):
			steer_angle = steer_target
	elif (steer_target > steer_angle):
		steer_angle += steer_speed * delta
		if (steer_target < steer_angle):
			steer_angle = steer_target
	steering = steer_angle
