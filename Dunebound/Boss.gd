extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var action : int
var can_action

@onready var Player = Global.Player
@onready var tp_container = $"../TPContainer"
@onready var tp_spots = {
	"1" = tp_container.get_node("Tp1").global_position,
	"2" = tp_container.get_node("Tp2").global_position,
	"3" = tp_container.get_node("Tp3").global_position,
}



func _ready():
	print(Player)


func _physics_process(delta):
	
	if can_action:
		action = (randi_range(1, 2))
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
	var tp_location = tp_spots[randomValue]
	global_position = tp_location
	await get_tree().create_timer(1).timeout
	can_action = true
	

func close_range_attack():
	pass

func long_range_attack():
	pass
