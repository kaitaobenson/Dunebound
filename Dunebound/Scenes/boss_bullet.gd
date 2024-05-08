extends CharacterBody2D

signal tracking_done

var Player = Global.Player
var velociter : Vector2
var SPEED = 400
var track_stop_process = false
var is_tracking = true
var track_stop_rotation_direction : float

func _ready():
	set_as_top_level(true)
	
	await tracking_done
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _physics_process(delta):
	if is_tracking:
		bullet_tracking()
	else:
		rotation -= track_stop_rotation_direction * delta * .5
	
	var forward_global_x = transform[0]
	velociter = forward_global_x
	var collision_info = move_and_collide(velociter.normalized() * delta * SPEED)
	


func bullet_tracking():
	var angle_to_player = atan2(Player.global_position.y - global_position.y, Player.global_position.x - global_position.x)
	if !track_stop_process && global_position.distance_to(Player.global_position) < 100.0:
		track_stop()
	
	if abs(angle_to_player - rotation) > deg_to_rad(180):
		rotation += deg_to_rad(360) * abs(angle_to_player) / angle_to_player
	
	var lerp = lerp(rotation, angle_to_player, .4)
	rotation = lerp

func track_stop():
	var angle = rotation
	await get_tree().create_timer(.1).timeout
	var angle_rotation_difference = angle - rotation
	if abs(angle_rotation_difference) > deg_to_rad(180):
		rotation += deg_to_rad(360) * abs(angle) / angle
	print(rad_to_deg(angle_rotation_difference))
	if abs(rad_to_deg(angle_rotation_difference)) > 15.0:
		is_tracking = false
		track_stop_rotation_direction = (angle_rotation_difference) / abs(angle_rotation_difference)
		emit_signal("tracking_done")


func get_damage_id():
	return "BossBullet"


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		queue_free()
