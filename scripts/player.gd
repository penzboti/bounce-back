extends CharacterBody3D


const SPEED = 6.0
const JUMP_VELOCITY = 2.5


func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		# rotate the face down and up
		$fish.rotation.x = velocity.y/JUMP_VELOCITY*0.3;

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# only able to move when jumping
	# to make the player constantly bounce
	if not is_on_floor():
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			# rotate in the moving direction
			var target_angle = atan2(-velocity.x, -velocity.z)
			$fish.rotation.y = lerp_angle($fish.rotation.y, target_angle, 15.0 * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED*0.1)
			velocity.z = move_toward(velocity.z, 0, SPEED*0.1)
	else:
		velocity.x = 0
		velocity.z = 0
		$fish.rotation.x = 0;

	move_and_slide()
