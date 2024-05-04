extends CharacterBody2D

var Player = Global.Player
var velociter : Vector2
var SPEED = 500
var track_stop_process = false
var is_tracking = true

func _ready():
	set_as_top_level(true)
	await get_tree().create_timer(12.0).timeout
	queue_free()

func _physics_process(delta):
	if is_tracking:
		bullet_tracking()
	var forward_global_x = transform[0]
	velociter = forward_global_x
	var collision_info = move_and_collide(velociter.normalized() * delta * SPEED)
	


func bullet_tracking():
	var angle_to_player = atan2(Player.global_position.y - global_position.y, Player.global_position.x - global_position.x)
	if !track_stop_process && global_position.distance_to(Player.global_position) < 100.0:
		track_stop(angle_to_player)
	print(rad_to_deg(angle_to_player - rotation))
	if abs(angle_to_player - rotation) > deg_to_rad(180):
		rotation += deg_to_rad(360) * abs(angle_to_player) / angle_to_player
	
	var lerp = lerp(rotation, angle_to_player, .8)
	rotation = lerp

func track_stop(angle):
	if abs(rad_to_deg(angle - rotation)) > 4.0:
		await get_tree().create_timer(.2).timeout
		is_tracking = false


func get_damage_id():
	return "BossBullet"


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		queue_free()
