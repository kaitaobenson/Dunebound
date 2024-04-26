extends CharacterBody2D

const ExplosionPath = preload("res://Scenes/close_range_explosion.tscn")
const MaxExplosionSize : float = 400.0
const explosion_expand_rate : float = 3.0
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var can_action = true
var explosion_is_active = false

@onready var Player = Global.Player
@onready var tp_container = $"../TPContainer"
@onready var AttackAreas = $"AttackDetectionContainer"

@onready var tp_spots = [
	tp_container.get_node("Tp1").global_position,
	tp_container.get_node("Tp2").global_position,
	tp_container.get_node("Tp3").global_position,
]
@onready var tp_distance_to_player = [
]

var ranges = {
	SMALL = false,
	MEDIUM = false,
	LARGE = false,
}




func _ready():
	pass


func _physics_process(delta):
	action_manager()
	tp_distance_to_player = [
		tp_spots[0].distance_to(Player.global_position),
		tp_spots[1].distance_to(Player.global_position),
		tp_spots[2].distance_to(Player.global_position),
	]

func action_manager():
	if can_action:
		can_action = false
		teleport()
		attack_manager()

func attack_manager():
	var amount_of_attacks = 3
	for i in amount_of_attacks:
		await close_range_explosion()
	can_action = true

func teleport():
	var randomValue = randi_range(0, 2)
	var tp_location = tp_spots[randomValue]
	global_position = tp_location
	await get_tree().create_timer(1).timeout
	

func close_range_explosion():
	var explosion = ExplosionPath.instantiate()
	var explosion_container = Node2D.new()
	add_child(explosion_container)
	var explosion_container_node = get_node(str(explosion_container.name))
	explosion_container_node.add_child(explosion)
	
	var explosion_size = 0.0
	explosion.get_node("ExplosionHitbox").shape.radius = explosion_size
	
	while explosion.get_node("ExplosionHitbox") != null && explosion.get_node("ExplosionHitbox").shape.radius < MaxExplosionSize:
		explosion.get_node("ExplosionHitbox").shape.radius = explosion_size
		explosion_size += explosion_expand_rate
		
		if get_tree() != null:
			await get_tree().create_timer(0.01).timeout
	
	if get_tree() != null:
		await get_tree().create_timer(0.25).timeout
	explosion_container_node.queue_free()



func mid_range_attack():
	pass

func long_range_attack():
	pass

func attack_range_finder():
	if $"Small".get_overlapping_bodies().has(Player):
		ranges["SMALL"] = true
	else:
		ranges["SMALL"] = false
		if $"Medium".get_overlapping_bodies().has(Player):
			ranges["MEDIUM"] = true
		else:
			ranges["MEDIUM"] = false
			if $"Large".get_overlapping_bodies().has(Player):
				ranges["LARGE"] = true
			else:
				ranges["LARGE"] = false



