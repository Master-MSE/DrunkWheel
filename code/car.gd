extends VehicleBody3D

const STEER_SPEED = 2
const STEER_LIMIT = 0.3
const BRAKE_STRENGTH = 2.0

@export var engine_force_value := 100.0

var previous_speed := linear_velocity.length()
var _steer_target := 0.0
var cons_alcool=		[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
var cons_aclcool_fac=	[0.0,0.1,0.3,0.4,0.4,0.4,0.2,0.1]
var alcool_absorbtion :=0.2
var tauxalcool := 0.0

#@onready var desired_engine_pitch: float = $EngineSound.pitch_scale

func _physics_process(delta: float):
	var fwd_mps := (linear_velocity * transform.basis).x

	_steer_target = Input.get_axis(&"right", &"left")
	_steer_target *= STEER_LIMIT

	# Engine sound simulation (not realistic, as this car script has no notion of gear or engine RPM).
	#desired_engine_pitch = 0.05 + linear_velocity.length() / (engine_force_value * 0.5)
	# Change pitch smoothly to avoid abrupt change on collision.
	#$EngineSound.pitch_scale = lerpf($EngineSound.pitch_scale, desired_engine_pitch, 0.2)

	if abs(linear_velocity.length() - previous_speed) > 1.0:
		# Sudden velocity change, likely due to a collision. Play an impact sound to give audible feedback,
		# and vibrate for haptic feedback.
		#$ImpactSound.play()
		Input.vibrate_handheld(100)
		for joypad in Input.get_connected_joypads():
			Input.start_joy_vibration(joypad, 0.0, 0.5, 0.1)

	# Automatically accelerate when using touch controls (reversing overrides acceleration).
	if DisplayServer.is_touchscreen_available() or Input.is_action_pressed(&"forward"):
		# Increase engine force at low speeds to make the initial acceleration faster.
		var speed := linear_velocity.length()
		if speed < 5.0 and not is_zero_approx(speed):
			engine_force = clampf(engine_force_value * 5.0 / speed, 0.0, 100.0)
		else:
			engine_force = engine_force_value

		if not DisplayServer.is_touchscreen_available():
			# Apply analog throttle factor for more subtle acceleration if not fully holding down the trigger.
			engine_force *= Input.get_action_strength(&"forward")
	else:
		engine_force = 0.0

	if Input.is_action_pressed(&"reverse"):
		# Increase engine force at low speeds to make the initial reversing faster.
		var speed := linear_velocity.length()
		if speed < 5.0 and not is_zero_approx(speed):
			engine_force = -clampf(engine_force_value * BRAKE_STRENGTH * 5.0 / speed, 0.0, 100.0)
		else:
			engine_force = -engine_force_value * BRAKE_STRENGTH

		# Apply analog brake factor for more subtle braking if not fully holding down the trigger.
		engine_force *= Input.get_action_strength(&"reverse")
	
	
	if Input.is_action_just_pressed(&"alcool_up"):
		cons_alcool[0]+=1.0;
	if Input.is_action_just_pressed(&"alcool_down"):
		cons_alcool[0]-=1.0;

	
	
	steering = move_toward(steering, _steer_target, STEER_SPEED * delta)

	previous_speed = linear_velocity.length()


func _on_alcool_timer_timeout() -> void:
	var time_now = Time.get_ticks_msec() / 1000.0  # Temps actuel en secondes
	var phase_offset = (PI - fmod(time_now, TAU))
	RenderingServer.global_shader_parameter_set("phase_time",phase_offset);
	tauxalcool-=alcool_absorbtion
	if tauxalcool<0.0:
		tauxalcool=0.0
	for i in range(cons_alcool.size()):
		tauxalcool += cons_alcool[i] * cons_aclcool_fac[i]
	for i in range(cons_alcool.size()-1,0,-1):
		cons_alcool[i] = cons_alcool[i-1]
	cons_alcool[0]=0.0
	prints(time_now)
	RenderingServer.global_shader_parameter_set("tauxalcool",tauxalcool);
