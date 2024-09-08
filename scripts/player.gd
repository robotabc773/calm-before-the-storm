extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * 0.2)
		
	
	if Input.is_action_pressed("float"):
		#print_debug("floating")
		var space_state = get_world_2d().direct_space_state
		var rayResult = space_state.intersect_ray(PhysicsRayQueryParameters2D.create(global_position, global_position + Vector2(0, 200)))
		if(!rayResult.is_empty()):
			#print_debug("ray pos: " + str(rayResult.position))
			var distance = global_position - rayResult.position
			var forcePower: float = distance.y / -200
			forcePower = 1 - easeOutQuad(forcePower)
			#print_debug(forcePower)
			var vel = -200 * forcePower
			print_debug(vel)
			velocity.y += (-200 * forcePower)
	
	
	move_and_slide()

func easeOutQuad(x: float) -> float:
	return 1 - (1 - x) * (1 - x)
