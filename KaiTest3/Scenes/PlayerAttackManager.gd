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
var active_inputs = []

var _attack_cooldown_over = true
var ALL_ANIMATIONS = preload("res://PlayerAnimations.gd").ALL_ANIMATIONS

@onready var _anim_manager = $AnimationManager

var current_collision: Node 

func _process(delta):
	### CHOOSE WEAPON TYPE ###
	var one_is_pressed: bool = Input.is_action_just_pressed("switch_weapon_1")
	var two_is_pressed: bool = Input.is_action_just_pressed("switch_weapon_2")
	if one_is_pressed:
		attack[0] = ATTACKS.SHORT_ATTACK
	if two_is_pressed:
		attack[0] = ATTACKS.LONG_ATTACK
		
	### CHOOSE DIRECTION ###
	var a_is_pressed: bool = Input.is_action_pressed("move_left")
	var d_is_pressed: bool = Input.is_action_pressed("move_right")
	var w_is_pressed: bool = Input.is_action_pressed("look_up")
	var s_is_pressed: bool = Input.is_action_pressed("look_down")
	
	if w_is_pressed:
		if active_inputs.has(DIRECTIONS.W) == false:
			active_inputs.append(DIRECTIONS.W)
	else:
		active_inputs.erase(DIRECTIONS.W)
		
	if s_is_pressed:
		if active_inputs.has(DIRECTIONS.S) == false:
			active_inputs.append(DIRECTIONS.S)
	else:
		active_inputs.erase(DIRECTIONS.S)
	
	if !w_is_pressed && !s_is_pressed:
		if Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"):
			if active_inputs.has(DIRECTIONS.AD) == false:
				active_inputs.append(DIRECTIONS.AD)
		else:
			active_inputs.erase(DIRECTIONS.AD)
			
	if active_inputs.size() > 0:
		attack[1] = active_inputs[int(active_inputs.size()) - 1]

	
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
