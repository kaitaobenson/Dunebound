extends Node2D

class_name HealthComponent

@export var max_health : int = 10
var health : int

func _ready():
	health = max_health
	set_health_bar_max()
	
	
func damage(attack:Attack):
	health -= attack.attack_damage
	update_health_bar()
	
	if health <= 0:
		$"../".die()
		
func update_health_bar():
	if has_bar() != null:
		get_node(str(has_bar())).set_value_no_signal(health)
		
		
func set_health_bar_max():
	if has_bar() != null:
		get_node(str(has_bar())).max_value = max_health
		

func has_bar():
	for child in get_children():
		if child is TextureProgressBar:
			return child.name
