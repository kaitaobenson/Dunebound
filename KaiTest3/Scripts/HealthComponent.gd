extends Node2D

class_name HealthComponent

@export var max_health: int = 100
@export var animation_sprite: AnimatedSprite2D
@export_multiline var health_bar: String
var health : int

func _ready():
	health = max_health
	update_health_bar()

func damage(attack:Attack):
	if attack.attack_damage != 0:
		health -= attack.attack_damage
		damaged_visuals()
		update_health_bar()
	if health <= 0:
		await get_tree().create_timer(0.2).timeout
		$"../".die()

func damaged_visuals():
	if animation_sprite != null:
		animation_sprite.modulate = Color(255, 255, 255)
		await get_tree().create_timer(0.2).timeout
		animation_sprite.modulate = Color(1, 1, 1, 1)

func update_health_bar():
	if get_node(health_bar) != null:
		get_node(health_bar).set_health(health)
