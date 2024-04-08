extends Node

enum TEMP_STATES {
	HOT,
	COLD,
	NORMAL
}

var outside_temp_status: TEMP_STATES
var player_temp: float

@onready var _health_component = $"../Player/HealthComponent"
@onready var _hurtbox_component = $"../Player/HurtboxComponent"

func _process(delta):
	if _hurtbox_component.is_in_water():
		print("WATER")
	elif _hurtbox_component.is_in_fire():
		print("FIRE")


func update_player_temp_status():
	if Global.temperature > 70:
		outside_temp_status = TEMP_STATES.HOT
	elif Global.temperature < 20:
		outside_temp_status = TEMP_STATES.COLD
	else:
		outside_temp_status = TEMP_STATES.NORMAL
