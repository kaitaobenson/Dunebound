extends Node

const _HOT_LIMIT = 65
const _COLD_LIMIT = 35
const _COEFFICIENT = 0.2

var _timer:float

func _process(delta):
	_timer += delta
	if _timer >= 1:
		_timer = 0
		take_temperature_damage()

func take_temperature_damage():
	
	if Global.temperature > _HOT_LIMIT:
		%Player.take_damage((Global.temperature - _HOT_LIMIT) * _COEFFICIENT, self)
		
	if Global.temperature < _COLD_LIMIT:
		%Player.take_damage((_COLD_LIMIT - Global.temperature) * _COEFFICIENT, self)
