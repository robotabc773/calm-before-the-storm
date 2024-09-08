extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

var ctimer = 0.0
var ctime = false
@export var ctime_max = 0.5

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	ctimef(delta)
	if Input.is_action_just_pressed("ui_accept") and ctime:
		velocity.y = JUMP_VELOCITY
		ctimer = ctime_max

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func ctimef(delta: float):
	if is_on_floor() and ctimer != 0.0:
		ctimer = 0.0
	else:
		ctimer += delta
	ctime = ctimer < ctime_max
