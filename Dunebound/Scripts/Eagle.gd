extends Node2D


@onready var begin_pos = position
@onready var area = $"Area2D"


var dist_from_begin_pos = 0
var angle_to_begin_pos = 0

var wander_speed = 2
var wander_angle = 45
var wander_time = 0


func _physics_process(delta):
	dist_from_begin_pos = position.distance_to(begin_pos)
	angle_to_begin_pos = rad_to_deg(position.angle_to(begin_pos))
	
	print(dist_from_begin_pos)
	
	if area.get_overlapping_bodies().has(Global.Player):
		# ATTACK
		pass
	else:
		# WANDER
		if dist_from_begin_pos > 400:
			pass
			# GO BACK
			
		else:
			pass
			# GO FORWARDS
			wander_time = randi_range(20, 500)
			move_towards(wander_angle, wander_speed, wander_time)


func move_towards(angle: int, speed: int, time: int):
	var x_speed
	var y_speed
	
	angle = ((angle % 360) + 360) % 360
	x_speed = speed * cos(deg_to_rad(angle))
	y_speed = speed * sin(deg_to_rad(angle))
	
	position.x += x_speed
	position.y += y_speed
