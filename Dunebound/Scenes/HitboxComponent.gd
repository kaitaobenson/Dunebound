extends Area2D

@onready var health_component = $"../HealthComponent"

func damage(attack: Attack):
	health_component.damage(attack)
	print(attack.attack_damage)
