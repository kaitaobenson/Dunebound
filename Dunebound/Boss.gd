extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var Player = Global.Player
var action : int
var can_action

@onready var tp_container = $"../TPContainer"
@onready var tp_spots = {
	"1" = tp_container.get_node("Tp1").global_position,
	"2" = tp_container.get_node("Tp2").global_position,
	"3" = tp_container.get_node("Tp3").global_position,
}



func _ready():
	pass



func _physics_process(delta):
	action = (randi_range(1, 2))
	
	if can_action:
		if action == 1:
			teleport()
		elif action == 2:
			if Player.global_position.distance_to(global_position) < 100:
				close_range_attack()
			else:
				long_range_attack()
	
	


func teleport():
	can_action = false
	var randomValue = randi_range(1, 3)
	var tp_location = tp_spots[randomValue.randomize()]
	global_position = tp_location
	await get_tree().create_timer(1).timeout
	can_action = true
	

func close_range_attack():
	pass

func long_range_attack():
	pass
