extends Node

const _HOT_LIMIT: float = 65
const _COEFFICIENT: float = 0.2
const _COLD_LIMIT: float = 35

var _timer: float
var can_take_damage: bool = true

var player_temp: float

@onready var _health_component = $"../Player/HealthComponent"
@onready var _hurtbox = $"../Player/HurtboxComponent"

"""
func _ready():
	player_temp = Global.temperature

func _process(delta):
	if _hurtbox.is_in_shelter():
		in_shelter()
	else:
		player_ease_to_global_temp()
		
		
	_timer += delta
	if can_take_damage:
		if _timer >= 1:
			_timer = 0
			take_temperature_damage()
			
			
func take_temperature_damage():
	if player_temp > _HOT_LIMIT:
		make_attack((player_temp - _HOT_LIMIT) * _COEFFICIENT)
	if player_temp < _COLD_LIMIT:
		make_attack((_COLD_LIMIT - player_temp) * _COEFFICIENT)
		
		
func make_attack(damage : float):
	var attack = Attack.new()
	attack.attack_damage = damage
	_health_component.damage(attack)
	
	
func in_shelter():
	protect_from_cold(5)
	protect_from_hot(5)
	
	
func player_ease_to_global_temp():
	if player_temp < Global.temperature:
		player_temp += 1
	if player_temp > Global.temperature:
		player_temp -= 1
		
		
func protect_from_cold(rate):
	if player_temp > 50:
		player_temp -= rate
func protect_from_hot(rate):
	if player_temp < 50:
		player_temp += rate
"""
