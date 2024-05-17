extends Node2D


@onready var begin_pos = position
@onready var area = $"Area2D"

var wander_time_elapsed : float = 0.0
var going_back : bool = false

var dist_from_begin_pos = 0
var angle_to_begin_pos = 0

var wander_speed = 5
var wander_angle = 0
var wander_time = 0

func _ready():
	new_wander()


func _physics_process(delta):
	wander_time_elapsed += delta
	
	dist_from_begin_pos = position.distance_to(begin_pos)
	angle_to_begin_pos = rad_to_deg(atan2(position.y - begin_pos.y, position.x - begin_pos.x))
	
	if going_back && dist_from_begin_pos < 200:
		going_back = false
	
	if area.get_overlapping_bodies().has(Global.Player):
		# ATTACK
		pass
	else:
		# GO FORWARDS
		move_towards(wander_angle, wander_speed)
		# WANDER
		if dist_from_begin_pos > 600:
			go_back()
			# GO BACK
		elif wander_time_elapsed > wander_time && !going_back:
			# NEW WANDER
			new_wander()
		
		


func move_towards(angle: int, speed: int):
	var x_speed
	var y_speed
	
	angle = ((angle % 360) + 360) % 360
	x_speed = speed * cos(deg_to_rad(angle))
	y_speed = speed * sin(deg_to_rad(angle))
	
	position.x += x_speed
	position.y += y_speed

func new_wander():
	wander_angle = randi_range(-180,180)
	wander_time = randi_range(3, 5)
	wander_time_elapsed = 0

func go_back():
	going_back = true
	wander_angle = angle_to_begin_pos - 180
