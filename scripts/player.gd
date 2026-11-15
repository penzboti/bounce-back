extends CharacterBody3D

const SPEED = 6.0
const JUMP_VELOCITY = 4.5

const PUSH_FORCE = 0.5

var in_trampoline = false
var no_input = false
var prev_dir: Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		# rotate the face down and up
		$fish.rotation.x = velocity.y/JUMP_VELOCITY*0.3;

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if in_trampoline:
			velocity.y *= 3

	# only able to move when jumping
	# to make the player constantly bounce
	if not is_on_floor():
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction == prev_dir * -1:
			# cant 180
			# this will be fun watching people die :)
			pass
		elif direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			# rotate in the moving direction
			var target_angle = atan2(-velocity.x, -velocity.z)
			$fish.rotation.y = lerp_angle($fish.rotation.y, target_angle, 15.0 * delta)
			prev_dir = direction
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED*0.1)
			velocity.z = move_toward(velocity.z, 0, SPEED*0.1)
	else:
		velocity.x = 0
		velocity.z = 0
		$fish.rotation.x = 0;


	move_and_slide()

	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		var collider = collision.get_collider()
		if collider == null:
			continue

		# checking car collision
		if collision.get_collider().is_in_group("car"):
			var car = collision.get_collider()
			# we check that we are hitting it from above.
			var vec = Vector3.RIGHT if car.flip == 1 else Vector3.LEFT
			if vec.dot(collision.get_normal()) > 0.1 and global_position.y < 0.8:
				die()
				break

		# checking box collision
		if collider is RigidBody3D:
			collider.apply_central_impulse(-collision.get_normal() * PUSH_FORCE)

func die() -> void:
	print("death")
	# get_tree().reload_current_scene()
	pass
