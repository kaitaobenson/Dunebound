extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const gravity = 500;
@onready var anim = get_node("AnimationPlayer")
@onready var animSprite = get_node("AnimatedSprite2D")

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
	if velocity.x == 0:
		anim.stop()
	
	if direction == 1:
		anim.play("Run")
		animSprite.flip_h = false
		
		velocity.x = direction * SPEED
	if direction == -1:
		anim.play("Run")
		animSprite.flip_h = true
		
		velocity.x = direction * SPEED
	if direction == 0:
		velocity.x = 0

	if velocity.y > 0:
		pass;

	move_and_slide()
