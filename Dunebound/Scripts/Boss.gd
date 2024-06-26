extends CharacterBody2D

signal laser_rect_phase_1
signal laser_rect_phase_2
signal laser_rect_done

const bulletPath = preload("res://Scenes/boss_bullet.tscn")
const ExplosionPath = preload("res://Scenes/CloseRangeExplosion.tscn")
const MaxExplosionScale = 5
const explosion_expand_rate : float = .01
const SPEED = 300.0
const JUMP_VELOCITY = -400.0


var can_action = true
var explosion_is_active = false
var laser_is_shooting = false
var laser_track_speed : float = .6


@onready var Player = Global.Player
@onready var tp_container = $"../TPContainer"
@onready var AttackAreas = $"AttackDetectionContainer"
@onready var laser_pivot = $"laser_pivot"
@onready var laser_hitbox = $"laser_pivot/laser_area/laser_hitbox"
@onready var laser_colorRect_outer = $"laser_pivot/laser_control/Outerlaserlayer"
@onready var laser_colorRect_inner = $"laser_pivot/laser_control/Innerlaserlayer"
@onready var Laser_Warning = $"laser_pivot/laser_control/LaserWarning"
@onready var bulletSpawn = $"laser_pivot/BulletSpawnPosition"


@onready var tp_spots = [
	tp_container.get_node("Tp1").global_position,
	tp_container.get_node("Tp2").global_position,
	tp_container.get_node("Tp3").global_position,
	tp_container.get_node("Tp4").global_position,
	tp_container.get_node("Tp5").global_position,
	tp_container.get_node("Tp6").global_position,
	tp_container.get_node("Tp7").global_position,
	tp_container.get_node("Tp8").global_position,
	tp_container.get_node("Tp9").global_position,
	tp_container.get_node("Tp10").global_position,
]
@onready var tp_distance_to_player = [
]

var ranges = {
	SMALL = false,
	MEDIUM = false,
	LARGE = false,
}




func _ready():
	laser_hitbox.scale.y = 0

func _physics_process(delta):
	attack_range_finder()
	laser_tracking()
	action_manager()
	


func action_manager():
	if can_action:
		can_action = false
		teleport()
		await get_tree().create_timer(.5).timeout
		attack_manager()

func attack_manager():
	var amount_of_attacks = randi_range(0, 5)
	for i in amount_of_attacks:
		if ranges["SMALL"]:
			await close_range_explosion()
		elif ranges["MEDIUM"]:
			await mid_range_laser_attack()
		elif ranges["LARGE"]:
			await long_range_attack()
		if i != amount_of_attacks:
			await get_tree().create_timer(1.0).timeout
	await get_tree().create_timer(5.0).timeout
	can_action = true

func teleport():
	var tpRandomness = randi_range(1, 5)
	var tp_location = tp_spots[tpRandomness]
	global_position = tp_location
	await get_tree().create_timer(1).timeout
	

func close_range_explosion():
	var explosion = ExplosionPath.instantiate()
	add_child(explosion)
	
	var explosion_scale = .25
	var explosion_circle = explosion.get_node("circleBoom")
	var explosion_hitbox = explosion.get_node("ExplosionHitbox")
	
	while explosion.get_node("ExplosionHitbox") != null && explosion.get_node("ExplosionHitbox").scale.x < MaxExplosionScale:
		explosion_hitbox.scale.x = explosion_scale
		explosion_hitbox.scale.y = explosion_scale
		explosion_circle.scale.x = explosion_scale
		explosion_circle.scale.y = explosion_scale
		explosion_scale += explosion_expand_rate
		await get_tree().create_timer(0.001).timeout
	
	await get_tree().create_timer(0.25).timeout
	explosion.queue_free()




func mid_range_laser_attack():
	laser_colorect_handler()
	var laser_track_tween : Tween = get_tree().create_tween()
	laser_track_tween.tween_property(self, "laser_track_speed", 0.0, 3.0)
	await get_tree().create_timer(3.0).timeout
	
	emit_signal("laser_rect_phase_1")
	laser_hitbox.disabled = false
	var laser_hitbox_expand_tween : Tween = get_tree().create_tween()
	laser_hitbox_expand_tween.tween_property(laser_hitbox, "scale", Vector2(1,1), .5)
	await get_tree().create_timer(.75).timeout
	emit_signal("laser_rect_phase_2")
	var laser_hitbox_shrink_tween : Tween = get_tree().create_tween()
	laser_hitbox_shrink_tween.tween_property(laser_hitbox, "scale", Vector2(1,0), .5)
	await get_tree().create_timer(.5).timeout
	laser_hitbox.disabled = true
	await laser_rect_done
	laser_track_speed = .6

func laser_tracking():
	var angle_to_player = atan2(Player.global_position.y - laser_pivot.global_position.y, Player.global_position.x - laser_pivot.global_position.x)
	
	if abs(angle_to_player - laser_pivot.rotation) > deg_to_rad(180):
		laser_pivot.rotation += deg_to_rad(360) * abs(angle_to_player) / angle_to_player
	
	var lerp = lerp(laser_pivot.rotation, angle_to_player, laser_track_speed)
	laser_pivot.rotation = lerp

func laser_colorect_handler():
	laser_colorRect_inner.size = Vector2(780, 0)
	laser_colorRect_outer.size = Vector2(780, 0)
	laser_colorRect_inner.set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT, Control.PRESET_MODE_KEEP_SIZE)
	laser_colorRect_outer.set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT, Control.PRESET_MODE_KEEP_SIZE)
	Laser_Warning.visible = true
	
	await laser_rect_phase_1
	Laser_Warning.visible = false
	laser_colorRect_inner.visible = true
	laser_colorRect_outer.visible = true
	var laser_inner_rect_expand_tween : Tween = get_tree().create_tween()
	laser_inner_rect_expand_tween.tween_property(laser_colorRect_inner, "size", Vector2(780, 40), .5)
	var laser_outer_rect_expand_tween : Tween = get_tree().create_tween()
	laser_outer_rect_expand_tween.tween_property(laser_colorRect_outer, "size", Vector2(780, 92), .5)
	
	while laser_colorRect_outer.size.y < 90.0:
		laser_colorRect_inner.set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT, Control.PRESET_MODE_KEEP_SIZE)
		laser_colorRect_outer.set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT, Control.PRESET_MODE_KEEP_SIZE)
		await get_tree().create_timer(.001).timeout
	
	await laser_rect_phase_2
	var laser_inner_rect_shrink_tween : Tween = get_tree().create_tween()
	laser_inner_rect_shrink_tween.tween_property(laser_colorRect_inner, "size", Vector2(780, 0), .5)
	var laser_outer_rect_shrink_tween : Tween = get_tree().create_tween()
	laser_outer_rect_shrink_tween.tween_property(laser_colorRect_outer, "size", Vector2(780, 0), .5)
	
	while laser_colorRect_outer.size.y > 0.0:
		laser_colorRect_inner.set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT, Control.PRESET_MODE_KEEP_SIZE)
		laser_colorRect_outer.set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT, Control.PRESET_MODE_KEEP_SIZE)
		await get_tree().create_timer(.001).timeout
	laser_colorRect_inner.visible = false
	emit_signal("laser_rect_done")


func long_range_attack():
	var bullet = bulletPath.instantiate()
	var bullet_pos = bulletSpawn.global_position
	add_child(bullet)
	bullet.global_position = bullet_pos
	bullet.velociter = Player.global_position - bullet.global_position



func attack_range_finder():
	if $"Small".get_overlapping_bodies().has(Player):
		ranges["SMALL"] = true
	else:
		ranges["SMALL"] = false
		if $"Medium".get_overlapping_bodies().has(Player):
			ranges["MEDIUM"] = true
		else:
			ranges["MEDIUM"] = false
			if $"Large".get_overlapping_bodies().has(Player):
				ranges["LARGE"] = true
			else:
				ranges["LARGE"] = false
				
				






func _on_laser_area_body_entered(body):
	if body.name == "Player":
		laser_hitbox.disabled = true
