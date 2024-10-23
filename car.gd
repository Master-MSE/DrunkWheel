extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14
# meters per second.
@export var bounce_impulse = 16
var target_velocity = Vector3.ZERO
signal alcohol_collected
	
	
	
func _physics_process(delta):
	
	for index in range(get_slide_collision_count()):
		# We get one of the collisions with the player
		var collision = get_slide_collision(index)
		# If the collision is with ground
		if collision.get_collider() == null:
			continue
		# If the collider is with a mob
		if collision.get_collider().is_in_group("alcool"):
			var alcool = collision.get_collider()
			# we check that we are hitting it from above.
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				# If so, we squash it and bounce.
				alcool.self_delet()
				emit_signal("alcohol_collected")
				# Prevent further duplicate calls.
				break
				
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x -= 1
	if Input.is_action_pressed("move_left"):
		direction.x += 1
	if Input.is_action_pressed("move_up"):
		direction.z += 1
	if Input.is_action_pressed("move_down"):
		direction.z -= 1
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Moving the Character
	velocity = target_velocity
	move_and_slide()
