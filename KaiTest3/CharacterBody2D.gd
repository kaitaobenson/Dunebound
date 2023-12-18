extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const gravity = 500;

func ready():
	pass;
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#its my keybind systems time to shine!
	var direction = Input.get_axis("ui_left", "move-right")

	
	#horiz movement
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			pass;
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			pass;
	if velocity.y > 0:
		pass;

	move_and_slide()
