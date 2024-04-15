extends Node2D

class_name HealthComponent

@export var max_health: int = 100
@export var animation_sprite: AnimatedSprite2D
@export_multiline var health_bar: String

var finished_death: bool = false
var done_tweening: bool = true
var health : int

@onready var _text_label = $RichTextLabel


func _ready():
	_text_label.modulate.a = 0
	health = max_health
	update_health_bar()


func _process(delta):
	if health <= 0:
		await get_tree().create_timer(0.2).timeout
		$"../".die()


func damage(attack: Attack):
	if (attack.attack_damage != 0) && (attack.attack_damage != null):
		health -= attack.attack_damage
		damaged_visuals(attack.attack_damage)
		update_health_bar()


func damage_without_visuals(attack: Attack):
	if (attack.attack_damage != 0) && (attack.attack_damage != null):
		health -= attack.attack_damage
		update_health_bar()


func damaged_visuals(attack_damage: float):
	display_damage_value(attack_damage)
	
	if !finished_death:
		flash_white(attack_damage)
	if health <= 0:
		finished_death = true


func display_damage_value(attack_damage):
	if (animation_sprite != null) && (attack_damage > 0) && done_tweening:
		done_tweening = false
		_text_label.text = str(attack_damage)
		_text_label.visible = true
		get_tree().create_tween().tween_property(_text_label, "modulate:a", 1, 1)
		get_tree().create_tween().tween_property(_text_label, "position:y", _text_label.position.y - 50, 1)
		
		await get_tree().create_timer(1.1).timeout
		_text_label.modulate.a = 0
		get_tree().create_tween().tween_property(_text_label, "position:y", _text_label.position.y + 50, 0)
		done_tweening = true


func flash_white(attack_damage):
	if (animation_sprite != null) && (attack_damage > 0):
		animation_sprite.modulate = Color(255, 255, 255)
		await get_tree().create_timer(0.2).timeout
		animation_sprite.modulate = Color(1, 1, 1, 1)


func update_health_bar():
	if get_node(health_bar) != null:
		get_node(health_bar).set_health(health)
