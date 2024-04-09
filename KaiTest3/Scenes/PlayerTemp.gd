extends Node

enum TEMP_STATES {
	COLD,
	NORMAL,
	HOT
}
const time_before_damage: float = 1
const damage: float = 10
const ease_to_outside_temp_value: float = 5

var outside_temp_status: TEMP_STATES
var player_temp: float = 0

@onready var _health_component = $"../Player/HealthComponent"
@onready var _hurtbox_component = $"../Player/HurtboxComponent"

func _ready():
	player_temp = Global.temperature


func _process(delta):
	update_player_temp_status()
	ease_toward_outside_temp()
	if outside_temp_status == TEMP_STATES.COLD:
		pass
	
	if _hurtbox_component.is_in_water():
		print("WATER")
	elif _hurtbox_component.is_in_fire():
		print("FIRE")


func ease_toward_outside_temp():
	#Add / subtract to outside temp
	if (Global.temperature - player_temp) > ease_to_outside_temp_value:
		player_temp += ease_to_outside_temp_value
	elif (Global.temperature - player_temp) < -ease_to_outside_temp_value:
		player_temp -= ease_to_outside_temp_value
	
	#Keep player_temp within boundries
	if player_temp > 100:
		player_temp = 100
	elif player_temp < 0:
		player_temp = 0


func update_player_temp_status():
	if Global.temperature > 70:
		outside_temp_status = TEMP_STATES.HOT
	if Global.temperature < 20:
		outside_temp_status = TEMP_STATES.COLD
	if !(Global.temperature > 70) && !(Global.temperature < 20):
		outside_temp_status = TEMP_STATES.NORMAL


