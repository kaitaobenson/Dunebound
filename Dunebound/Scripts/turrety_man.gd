extends CharacterBody2D


const SPEED = 300.0
const bulletPath = preload("res://Scenes/turret_bullet.tscn")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_see : bool = false
var can_fire = true

@onready var Player = Global.Player
@onready var line_of_sight = $"LineOfSightPivot/LineOfSight" as RayCast2D
@onready var line_of_sight_pivot = $"LineOfSightPivot" as Node2D

func _ready():
	pass

func _physics_process(delta):
	raycast_direction()
	is_in_range()
	if can_see && can_fire:
		fire_bullet()
	
	
	

func is_in_range():
	var who_i_see = line_of_sight.get_collider()
	var can_i_see = line_of_sight.is_colliding()
	if who_i_see == Player:
		can_see = true
	else:
		await get_tree().create_timer(0.25).timeout
		if who_i_see == Player:
			can_see = true
		else:
			can_see = false

func raycast_direction():
	var direction_to_player : Vector2 = Vector2(Player.global_position.x, Player.global_position.y - 8) - line_of_sight.position
	line_of_sight_pivot.look_at(direction_to_player)

func fire_bullet():
	can_fire = false
	var bullet = bulletPath.instantiate()
	var bullet_pos : Vector2
	# Prevents bullets from blocking line of sight
	line_of_sight.add_exception(bullet)
	# Offsets spawn position depending on if you are to the right or to the left
	# so it doesnt spawn inside the turret
	if Player.global_position.x - global_position.x > 0:
		bullet_pos = Vector2(global_position.x + 60, global_position.y - 30)
	else:
		bullet_pos = Vector2(global_position.x - 60, global_position.y - 30)
	
	var bullet_container = Node2D.new()
	add_child(bullet_container)
	var bullet_container_node = get_node(str(bullet_container.name))
	
	
	bullet_container_node.add_child(bullet)
	bullet.global_position = bullet_pos
	bullet.velociter = Player.global_position - bullet.global_position
	await get_tree().create_timer(1).timeout
	
	can_fire = true
	
	
