extends CharacterBody2D

signal laser_rect_phase_1
signal laser_rect_phase_2
signal laser_rect_done

const ExplosionPath = preload("res://Scenes/CloseRangeExplosion.tscn")
const MaxExplosionSize : float = 400.0
const explosion_expand_rate : float = 3.0
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var can_action = true
var explosion_is_active = false
var laser_is_shooting = false
var laser_track_speed : float = .8


@onready var Player = Global.Player
@onready var tp_container = $"../TPContainer"
@onready var AttackAreas = $"AttackDetectionContainer"
@onready var laser_pivot = $"laser_pivot"
@onready var laser_hitbox = $"laser_pivot/laser_area/laser_hitbox"
@onready var laser_colorRect_outer = $"laser_pivot/laser_control/Outerlaserlayer"
@onready var laser_colorRect_inner = $"laser_pivot/laser_control/Innerlaserlayer"
@onready var Laser_Warning = $"laser_pivot/laser_control/LaserWarning"

@onready var tp_spots = [
	tp_container.get_node("Tp1").global_position,
	tp_container.get_node("Tp2").global_position,
	tp_container.get_node("Tp3").global_position,
]
@onready var tp_distance_to_player = [
]

var ranges = {
	SMALL = false,
	MEDIUM = false,
	LARGE = false,
}




func _ready():
	pass

func _physics_process(delta):
	attack_range_finder()
	laser_tracking()
	action_manager()
	
	tp_distance_to_player = [
		tp_spots[0].distance_to(Player.global_position),
		tp_spots[1].distance_to(Player.global_position),
		tp_spots[2].distance_to(Player.global_position),
	]

func action_manager():
	if can_action:
		can_action = false
		teleport()
		attack_manager()

func attack_manager():
	var amount_of_attacks = 3.0
	for i in amount_of_attacks:
		if ranges["SMALL"]:
			await close_range_explosion()
		elif ranges["MEDIUM"]:
			long_range_laser_attack()
			await laser_rect_done
	if get_tree() != null:
		await get_tree().create_timer(3.0).timeout
	can_action = true

func teleport():
	var randomValue = randi_range(0, 2)
	var tp_location = tp_spots[randomValue]
	global_position = tp_location
	if get_tree() != null:
		await get_tree().create_timer(1).timeout
	

func close_range_explosion():
	var explosion = ExplosionPath.instantiate()
	var explosion_container = Node2D.new()
	add_child(explosion_container)
	var explosion_container_node = get_node(str(explosion_container.name))
	explosion_container_node.add_child(explosion)
	
	var explosion_size = 0.0
	explosion.get_node("ExplosionHitbox").shape.radius = explosion_size
	
	while explosion.get_node("ExplosionHitbox") != null && explosion.get_node("ExplosionHitbox").shape.radius < MaxExplosionSize:
		explosion.get_node("ExplosionHitbox").shape.radius = explosion_size
		explosion_size += explosion_expand_rate
		
		if get_tree() != null:
			await get_tree().create_timer(0.01).timeout
	
	if get_tree() != null:
		await get_tree().create_timer(0.25).timeout
	explosion_container_node.queue_free()

func laser_tracking():
	var angle_to_player = atan2(Player.global_position.y - laser_pivot.global_position.y, Player.global_position.x - laser_pivot.global_position.x)
	
	if abs(angle_to_player - laser_pivot.rotation) > deg_to_rad(180):
		laser_pivot.rotation += deg_to_rad(360) * abs(angle_to_player) / angle_to_player
	
	var lerp = lerp(laser_pivot.rotation, angle_to_player, laser_track_speed)
	laser_pivot.rotation = lerp

func mid_range_attack():
	pass

func long_range_laser_attack():
	laser_colorect_handler()
	var laser_track_tween : Tween = get_tree().create_tween()
	laser_track_tween.tween_property(self, "laser_track_speed", 0.0, 3.0)
	await get_tree().create_timer(3.0).timeout
	emit_signal("laser_rect_phase_1")
	laser_hitbox.disabled = false
	await get_tree().create_timer(1.0).timeout
	laser_hitbox.disabled = true
	emit_signal("laser_rect_phase_2")
	await laser_rect_done
	laser_track_speed = .8

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
	laser_outer_rect_expand_tween.tween_property(laser_colorRect_outer, "size", Vector2(780, 90), .5)
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
		if get_tree() != null:
			await get_tree().create_timer(.001).timeout
	laser_colorRect_inner.visible = false
	emit_signal("laser_rect_done")
