extends Node2D

@onready var _anim = $AnimatedSprite2D
@onready var _area = $"Area2D"

@onready var _right_side = $"RightSide"
@onready var _left_side = $"LeftSide"
@onready var _right_down = $"RightDown"
@onready var _left_down = $"LeftDown"

var begin_position: Vector2

var previous_fly_done = true
var previous_walk_done = true

var can_walk = true
var fly_triggered = false
#var direction = 1

var fly_once_trigger: bool = true
var walk_once_trigger: bool = true

var walk_direction
var walk_time = 0
var walk_timer = 0

var fly_direction

func _ready(): 
	begin_position = position


func _physics_process(delta):
	# RESET
	if !can_walk && begin_position.distance_to(Global.Player.global_position) > 1000:
		fly_triggered = false
		previous_fly_done = true
		previous_walk_done = true
		can_walk = true
		#position = begin_position
		modulate.a = 1
		_anim.stop()
		
	#FLY
	if _area.get_overlapping_bodies().has(Global.Player) || fly_triggered:
		walk_once_trigger = true
		
		can_walk = false
		fly_triggered = true
		
		if fly_once_trigger:
			fly_once_trigger = false
			previous_fly_done = false
			
			if Global.Player.global_position.x < position.x:
				fly_direction = 1
				
			elif Global.Player.global_position.x > position.x:
				fly_direction = -1
		
		_anim.play("Fly")
		position.y -= 7
		if fly_direction == 1:
			position.x += 7
			_anim.flip_h = false
		if fly_direction == -1:
			position.x -= 7
			_anim.flip_h = true
			
			
	#WALK
	else:
		fly_once_trigger = true
		
		if walk_once_trigger:
			walk_once_trigger = false
			previous_walk_done = false
			
			var random = randi_range(1,2)
			if random == 1:
				walk_direction = 1
			if random == 2:
				walk_direction = -1
			
			walk_time = randi_range(1 , 4)
			
			wait()
		
		walk_timer += delta
		if walk_timer >= walk_time:
			walk_timer = 0
			walk_once_trigger = true
		
		if walk_direction == 1:
			if _right_side.is_colliding() || !_right_down.is_colliding():
				walk_direction = -1
			position.x += 1
			_anim.play("Walk")
			_anim.flip_h = false
		if walk_direction == -1:
			if _left_side.is_colliding() || !_left_down.is_colliding():
					walk_direction = 1
			position.x -= 1
			_anim.play("Walk")
			_anim.flip_h = true


func wait():
	var direction = walk_direction
	walk_direction = 0
	_anim.stop()
	await get_tree().create_timer(randi_range(2,2)).timeout
	
	walk_direction = direction
