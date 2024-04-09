extends Node

enum TEMP_STATES {
	COLD,
	NORMAL,
	HOT
}
const player_heat_limit: float = 65
const player_cold_limit: float = 35

const time_before_damage: float = 1
const damage: float = 5

var ease_to_outside_temp_value: float = 1
var can_ease_to_outside_temp: bool = true

var outside_temp_status: TEMP_STATES

var player_temp_status: TEMP_STATES
var player_temp: float = 0

var can_take_damage: bool = true

@onready var _health_component: HealthComponent = $"../Player/HealthComponent"
@onready var _hurtbox_component = $"../Player/HurtboxComponent"
@onready var _temperature_label: RichTextLabel = $"../../UI/TempGauge"

func _ready():
	player_temp = Global.temperature


func _process(delta):
	update_player_temp_status()
	player_take_damage()
	keep_player_temp_within_boundries()
	
	_temperature_label.text = str(round(player_temp)) + ". F"
	
	if _hurtbox_component.is_in_water():
		if outside_temp_status == TEMP_STATES.HOT:
			player_temp = 50
			ease_to_outside_temp_value = 0
			
		elif outside_temp_status == TEMP_STATES.COLD:
			player_temp -= 7
			
	elif _hurtbox_component.is_in_fire():
		if outside_temp_status == TEMP_STATES.COLD:
			player_temp = 50
			ease_to_outside_temp_value = 0
			
		elif outside_temp_status == TEMP_STATES.HOT:
			player_temp += 7
	else:
		ease_toward_outside_temp()


func player_take_damage():
	if (player_temp_status == TEMP_STATES.HOT) || (player_temp_status == TEMP_STATES.COLD):
		if can_take_damage:
			can_take_damage = false
			
			var attack = Attack.new()
			attack.attack_damage = damage
			_health_component.damage(attack)
			
			await get_tree().create_timer(time_before_damage).timeout
			can_take_damage = true


func ease_toward_outside_temp():
	return_outside_temp_value()
	if can_ease_to_outside_temp:
		can_ease_to_outside_temp = false
		#Add / subtract to outside temp
		if (Global.temperature - player_temp) > ease_to_outside_temp_value:
			player_temp += ease_to_outside_temp_value
		elif (Global.temperature - player_temp) < -ease_to_outside_temp_value:
			player_temp -= ease_to_outside_temp_value
		
		
		await get_tree().create_timer(0.1).timeout
		can_ease_to_outside_temp = true


func return_outside_temp_value():
	if ease_to_outside_temp_value == 0:
		await get_tree().create_timer(3).timeout
		ease_to_outside_temp_value = 1


func update_player_temp_status():
	#Update outside_temp
	if Global.temperature > player_heat_limit:
		outside_temp_status = TEMP_STATES.HOT
	if Global.temperature < player_cold_limit:
		outside_temp_status = TEMP_STATES.COLD
	if !(Global.temperature > player_heat_limit) && !(Global.temperature < player_cold_limit):
		outside_temp_status = TEMP_STATES.NORMAL
	
	#Update player_temp
	if player_temp > player_heat_limit:
		player_temp_status = TEMP_STATES.HOT
	if player_temp < player_cold_limit:
		player_temp_status = TEMP_STATES.COLD
	if !(player_temp > player_heat_limit) && !(player_temp < player_cold_limit):
		player_temp_status = TEMP_STATES.NORMAL


func keep_player_temp_within_boundries():
	if player_temp > 100:
		player_temp = 100
	elif player_temp < 0:
		player_temp = 0

