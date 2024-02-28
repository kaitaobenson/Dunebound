extends Node

const _HOT_LIMIT : float = 65
const _COEFFICIENT : float = 0.2
const _COLD_LIMIT : float = 35

var _timer : float

@onready var _health_component = $"../Player/HealthComponent"

func _process(delta):
	_timer += delta
	if _timer >= 1:
		_timer = 0
		take_temperature_damage()
	
	
func take_temperature_damage():
	if Global.temperature > _HOT_LIMIT:
		make_attack((Global.temperature - _HOT_LIMIT) * _COEFFICIENT)
	if Global.temperature < _COLD_LIMIT:
		make_attack((_COLD_LIMIT - Global.temperature) * _COEFFICIENT)
		
		
func make_attack(damage : float):
	var attack = Attack.new()
	attack.attack_damage = damage
	_health_component.damage(attack)
