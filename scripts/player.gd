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
		if(velocity.x * direction < SPEED + 50):
			velocity.x += direction * 50
	elif !is_on_floor():
		velocity.x = move_toward(velocity.x, 0, 5)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * 0.1)
		
	
	if Input.is_action_pressed("float"):
		#print_debug("floating")
		
		
		
		#var rayResult = castRay(Vector2.from_angle(PI / 2) * 200)
		#if(!rayResult.is_empty()):
			#print_debug("ray pos: " + str(rayResult.position))
			#var distance: Vector2 = global_position - rayResult.position
			var distance: Vector2 = calculateForceVector(200)
			#print_debug(distance / 200)
			var forcePower: Vector2 = distance * -1
			print_debug("force: " + str(forcePower))
			forcePower *= (1 - easeOutQuad(forcePower.length()))
			#print_debug(forcePower)
			var vel = -400 * forcePower
			#print_debug(vel)
			velocity += (vel)
	
	
	move_and_slide()

func calculateForceVector(distance: float) -> Vector2:
	var vec := Vector2(0, 0)
	var totalVecs := 0
	for i in range(16):
		var rayResult = castRay(Vector2.from_angle((PI / 8) * i) * distance)
		if(!rayResult.is_empty()):
			vec += ((global_position - rayResult.position) / 200)
			totalVecs += 1
	if(totalVecs == 0):
		return vec
	return (vec / totalVecs)
		
		

func castRay(vec: Vector2) -> Dictionary:
	var space_state = get_world_2d().direct_space_state
	return space_state.intersect_ray(PhysicsRayQueryParameters2D.create(global_position, global_position + vec))

func easeOutQuad(x: float) -> float:
	return 1 - (1 - x) * (1 - x)
	
#func easeOutQuad(x: Vector2) -> Vector2:
	#return Vector2.ONE - (Vector2.ONE - x) * (Vector2.ONE - x)
