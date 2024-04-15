extends Node2D

const short_knife_base_damage = 35
const short_knife_charged_damage = 60
const short_knife_charge_time = 0.5

const short_knife_base_recover_time = 0.0
const short_knife_charge_recover_time = 0.3
@onready var short_knife_collision = $"AttackArea/Short"

const long_spear_base_damage = 50
const long_spear_charged_damage = 100
const long_spear_charge_time = 1.3

const long_spear_base_recover_time = 0.7
const long_spear_charge_recover_time = 0.8
@onready var long_spear_collision = $"AttackArea/Long"

var current_attack: Attack = Attack.new()

var attack_is_held: bool = false
var can_slash: bool = false
var has_charged: bool = false
var previous_attack_done: bool = true

var move_is_locked: bool = false
var jump_is_locked: bool = false

@onready var _anim_manager = $"../AnimationManager"
@onready var _anim_player = $"../AnimationManager/AnimationPlayer"
@onready var _slide = $"../Slide"
@onready var _boom = $"Boom"
@onready var _audio_manager = $"../AudioManager"


func _ready() -> void:
	pass



func _process(delta) -> void:
	if Input.is_action_just_pressed("switch_weapon_1") && !is_attacking():
		current_attack.attack_type = current_attack.ATTACKS.SHORT_KNIFE
	if Input.is_action_just_released("switch_weapon_2") && !is_attacking():
		current_attack.attack_type = current_attack.ATTACKS.LONG_SPEAR
		
		
	if Input.is_action_pressed("attack") && !has_charged && previous_attack_done && !_slide.is_sliding():
		attack_is_held = true
		has_charged = true
		if current_attack.attack_type == current_attack.ATTACKS.SHORT_KNIFE:
			charge_short_knife()
		if current_attack.attack_type == current_attack.ATTACKS.LONG_SPEAR:
			charge_long_spear()
		
	if !Input.is_action_pressed("attack") && (attack_is_held && previous_attack_done && can_slash):
		attack_is_held = false
		previous_attack_done = false
		await do_attack()
		previous_attack_done = true


func charge_short_knife() -> void:
	current_attack.attack_damage = short_knife_base_damage
	_anim_manager.change_animation(_anim_manager.ALL_ANIMATIONS.SHORT_ATTACK_BEGIN_1, true)
	await get_tree().create_timer(0.2).timeout
	can_slash = true
	
	var timer = get_tree().create_timer(short_knife_charge_time)
	var activated = false
	
	while attack_is_held:
		if timer.time_left == 0 && !activated:
			activated = true
			move_is_locked = true
			jump_is_locked = true
			current_attack.attack_damage = short_knife_charged_damage
			_anim_manager.modulate = Color(216, 105, 224, 1)
			_audio_manager.play(_audio_manager.ALL_SOUNDS.ATTACK_CHARGED)
			
		await get_tree().create_timer(0.1).timeout
		
	has_charged = false
	_anim_manager.modulate = Color(1,1,1,1)



func charge_long_spear() -> void:
	current_attack.attack_damage = long_spear_base_damage
	_anim_manager.change_animation(_anim_manager.ALL_ANIMATIONS.LONG_ATTACK_BEGIN_1, true)
	await get_tree().create_timer(0.2).timeout
	can_slash = true
	
	var timer = get_tree().create_timer(long_spear_charge_time)
	var activated = false
	
	while attack_is_held:
		if timer.time_left == 0 && !activated:
			activated = true
			move_is_locked = true
			jump_is_locked = true
			current_attack.attack_damage = long_spear_charged_damage
			_anim_manager.modulate = Color(216, 105, 224, 1)
			_audio_manager.play(_audio_manager.ALL_SOUNDS.ATTACK_CHARGED)
			
		await get_tree().create_timer(0.1).timeout
		
	has_charged = false
	_anim_manager.modulate = Color(1,1,1,1)



func do_attack() -> void:
	if current_attack.attack_type == current_attack.ATTACKS.SHORT_KNIFE && can_slash:
		can_slash = false
		var is_charged: bool
		if current_attack.attack_damage == short_knife_charged_damage:
			is_charged = true
			_boom.do_boom()
		elif current_attack.attack_damage == short_knife_base_damage:
			is_charged = false
		
		_anim_manager.change_animation(_anim_manager.ALL_ANIMATIONS.SHORT_ATTACK_END_1, true)
		_audio_manager.play(_audio_manager.ALL_SOUNDS.SHORT_ATTACK)
		
		
		short_knife_collision.disabled = false
		await get_tree().create_timer(0.05).timeout
		short_knife_collision.disabled = true
		
		await _anim_player.animation_finished
		if is_charged:
			await get_tree().create_timer(short_knife_charge_recover_time).timeout
		else:
			await get_tree().create_timer(short_knife_base_recover_time).timeout
		
		previous_attack_done = true
		move_is_locked = false
		jump_is_locked = false
		
		
	if current_attack.attack_type == current_attack.ATTACKS.LONG_SPEAR:
		can_slash = false
		var is_charged: bool
		if current_attack.attack_damage == long_spear_charged_damage:
			is_charged = true
			_boom.do_boom()
		elif current_attack.attack_damage == long_spear_base_damage:
			is_charged = false
		
		_anim_manager.change_animation(_anim_manager.ALL_ANIMATIONS.LONG_ATTACK_END_1, true)
		long_spear_collision.disabled = false
		await get_tree().create_timer(0.05).timeout
		long_spear_collision.disabled = true
		
		await _anim_player.animation_finished
		if is_charged:
			await get_tree().create_timer(long_spear_charge_recover_time).timeout
		else:
			await get_tree().create_timer(long_spear_base_recover_time).timeout
		
		previous_attack_done = true
		move_is_locked = false
		jump_is_locked = false


func reset_current_attack():
	current_attack = Attack.new()
func is_move_locked():
	return move_is_locked
func is_jump_locked():
	return jump_is_locked
func is_attacking():
	if move_is_locked || attack_is_held:
		return true
	else:
		return false


func _on_attack_area_area_entered(area):
	if area.is_in_group("Hurtbox"):
		area.has_method("damage")
		area.damage(current_attack)
