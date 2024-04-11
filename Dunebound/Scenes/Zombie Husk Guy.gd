extends CharacterBody2D
const detection_range = 300.0
const JUMP_VELOCITY = -400.0
var SPEED = 200.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var movement_direction = 1
var timerIsOver : bool = true
var can_see : bool = false
@onready var Player = Global.Player
@onready var line_of_sight = $"LineOfSightPivot/LineOfSight" as RayCast2D
@onready var line_of_sight_pivot = $"LineOfSightPivot" as Node2D

func _ready():
	pass

func _physics_process(delta):
	if  can_see == true:
		following()
		check_if_jump()
	else:
		idle()
	is_in_range()
	raycast_direction()
	
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = movement_direction * SPEED
	move_and_slide()
func _process(delta):
	pass


func is_in_range():
	var who_i_see = $"LineOfSightPivot/LineOfSight".get_collider()
	var can_i_see = $"LineOfSightPivot/LineOfSight".is_colliding()
	if who_i_see == Player:
		can_see = true
	else:
		await get_tree().create_timer(0.25).timeout
		if who_i_see == Player:
			can_see = true
		else:
			can_see = false
	
func raycast_direction():
	var direction_to_player : Vector2 = Vector2(Global.Player.global_position.x, Global.Player.global_position.y - 8) - line_of_sight.position
	line_of_sight_pivot.look_at(direction_to_player)

func check_if_jump():
	if timerIsOver && await check_if_moved() == false:
		timerIsOver = false
		velocity.y = JUMP_VELOCITY
		
		await get_tree().create_timer(1).timeout
		timerIsOver = true

func idle():
	SPEED = 100
	var leftwallcheck = $"Collision_Checks/leftwallcheck".is_colliding()
	var rightwallcheck = $"Collision_Checks/rightwallcheck".is_colliding()
	var leftfloorcheck = $"Collision_Checks/leftfloorcheck".is_colliding()
	var rightfloorcheck = $"Collision_Checks/rightfloorcheck".is_colliding()
	var leftsidecheck = $"Collision_Checks/leftsidecheck".is_colliding()
	var rightsidecheck = $"Collision_Checks/rightsidecheck".is_colliding()
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
