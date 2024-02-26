extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

var movement_direction
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if abs(Global.PlayerX - position.x) < 1:
		movement_direction = 0
	elif Global.PlayerX < position.x:
		movement_direction = -1
	elif Global.PlayerX > position.x:
		movement_direction = 1
	
	velocity.x = movement_direction * SPEED
	
	jump()
	move_and_slide()
	
func jump():
	if await check_if_moved() == false:
		velocity.y = JUMP_VELOCITY
		print(velocity.y)



func check_if_moved():
	var x1 = global_position.x
	var x2
	await get_tree().create_timer(0.1).timeout
	x2 = global_position.x
	if abs(abs(x1) - abs(x2)) < 7:
		return false
	else:
		return true
