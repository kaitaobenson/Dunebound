extends Node2D

enum ATTACKS {
	SHORT_ATTACK,
	LONG_ATTACK
}
enum DIRECTIONS {
	AD,
	W,
	S
}

var attack = [ATTACKS.SHORT_ATTACK, DIRECTIONS.AD]

var _attack_cooldown_over = true
var ALL_ANIMATIONS = preload("res://PlayerAnimations.gd").ALL_ANIMATIONS

@onready var _anim_manager = $AnimationManager

var current_collision: Node 

func _process(delta):
	### CHOOSE WEAPON TYPE ###
	if Input.is_action_just_pressed("switch_weapon_1"):
		attack[0] = ATTACKS.SHORT_ATTACK
	if Input.is_action_just_pressed("switch_weapon_2"):
		attack[0] = ATTACKS.LONG_ATTACK
		
	### CHOOSE DIRECTION ###
	if Input.is_action_just_pressed("look_up"):
		attack[1] = DIRECTIONS.W
	if Input.is_action_just_pressed("look_down"):
		attack[1] = DIRECTIONS.S
	if Input.is_action_just_pressed("move_right"):
		attack[1] = DIRECTIONS.AD
	if Input.is_action_just_pressed("move_left"):
		attack[1] = DIRECTIONS.AD
		
	### ATTACK ###
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && _attack_cooldown_over:
		turn_hitbox_on()
		_attack_cooldown_over = false
		
		var timer = get_tree().create_timer(0.2)
		while timer.time_left != 0:
			await get_tree().create_timer(0.1).timeout
			
		_attack_cooldown_over = true
		
		
func turn_hitbox_on():
	var attack_type:String = ATTACKS.keys()[attack[0]]
	var attack_direction:String = DIRECTIONS.keys()[attack[1]]
	var collision_node = get_node(attack_type.to_pascal_case() + "/" + attack_direction)
	collision_node.disabled = false
	await get_tree().create_timer(0.1).timeout
	collision_node.disabled = true
	
	

	
