extends Node2D

@onready var _anim = $AnimatedSprite2D
@onready var _area = $"Area2D"

@onready var _right_side = $"RightSide"
@onready var _left_side = $"LeftSide"
@onready var _right_down = $"RightDown"
@onready var _left_down = $"LeftDown"

var previous_fly_done = true
var previous_walk_done = true

var can_walk = true
var direction = 1


func _process(delta):
	if _area.get_overlapping_bodies().has(Global.Player):
		fly()
		can_walk = false
	else:
		walk()


func walk():
	if can_walk && previous_walk_done:
		previous_walk_done = false
		
		await get_tree().create_timer(randf_range(0,2)).timeout
		
		var random = randi_range(1,2)
		if random == 1:
			direction = 1
		if random == 2:
			direction = -1
		
		var i = randi_range(10,200)
		
		while i > 0:
			i -= 1
			if direction == 1:
				if _right_side.is_colliding() || !_right_down.is_colliding():
					direction = -1
					continue
				position.x += 1
				_anim.flip_h = false
			if direction == -1:
				if _left_side.is_colliding() || !_left_down.is_colliding():
					direction = 1
					continue
				position.x -= 1
				_anim.flip_h = true
			
			_anim.play("Walk")
			
			await get_tree().process_frame
		
		_anim.stop()
		previous_walk_done = true


func fly():
	if previous_fly_done:
		previous_fly_done = false
		
		_anim.play("Fly")
		
		if Global.Player.global_position.x < position.x:
			direction = 1
			
		elif Global.Player.global_position.x > position.x:
			direction = -1
		
		
		var i = 10000
		while i > 0:
			position.y -= 4
			if direction == 1:
				position.x += 4
				_anim.flip_h = false
			if direction == -1:
				position.x -= 4
				_anim.flip_h = true
			await get_tree().process_frame
			
		queue_free()
