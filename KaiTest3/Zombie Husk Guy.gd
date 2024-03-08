extends CharacterBody2D
const detection_range = 300.0
const JUMP_VELOCITY = -400.0
var SPEED = 200.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var movement_direction = 1
var timerIsOver : bool = true

func _physics_process(delta):
	if  abs(Global.Player.global_position.x - position.x) + abs(Global.Player.global_position.x - position.x) < detection_range:
		following()
		check_if_jump()
	else:
		idle()
	
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = movement_direction * SPEED
	move_and_slide()

func check_if_jump():
	if timerIsOver && await check_if_moved() == false:
		timerIsOver = false
		velocity.y = JUMP_VELOCITY
		
		await get_tree().create_timer(1).timeout
		timerIsOver = true
		
func idle():
	SPEED = 100
	var leftwallcheck = $"leftwallcheck".is_colliding()
	var rightwallcheck = $"rightwallcheck".is_colliding()
	var leftfloorcheck = $"leftfloorcheck".is_colliding()
	var rightfloorcheck = $"rightfloorcheck".is_colliding()
	var leftsidecheck = $"leftsidecheck".is_colliding()
	var rightsidecheck = $"rightsidecheck".is_colliding()
	if (movement_direction == 1 and rightwallcheck or !rightfloorcheck or rightsidecheck):
		movement_direction = -movement_direction
	if (movement_direction == -1 and leftwallcheck or !leftfloorcheck or leftsidecheck):
		movement_direction = -movement_direction

func following():
	SPEED = 300
	if abs(Global.Player.global_position.x - position.x) < 10:
		movement_direction = 0
	elif Global.Player.global_position.x < position.x:
		movement_direction = -1
	elif Global.Player.global_position.y > position.x:
		movement_direction = 1

func check_if_moved():
	var x1 = global_position.x
	var x2
	await get_tree().create_timer(0.1).timeout
	x2 = global_position.x
	if abs(abs(x1) - abs(x2)) < 7:
		return false
	else:
		return true
