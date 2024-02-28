extends Node

var _HOT_LIMIT = 65
var _COEFFICIENT = 0.2
var _COLD_LIMIT = 35

func _process(delta):
	await get_tree().create_timer(1).timeout
	take_temperature_damage()

func take_temperature_damage():
	print("ALHSD")
	if Global.temperature > _HOT_LIMIT:
		#%Player.take_damage((Global.temperature - _HOT_LIMIT) * _COEFFICIENT, self)
		pass
		
	if Global.temperature < _COLD_LIMIT:
		#%Player.take_damage((_COLD_LIMIT - Global.temperature) * _COEFFICIENT, self)
		pass
		
