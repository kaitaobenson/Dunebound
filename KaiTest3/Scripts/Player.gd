extends CharacterBody2D

const PUSH_FORCE = 100

const WALK_SPEED = 350
const SPRINT_SPEED = 600
const JUMP_VELOCITY = 700
const GRAVITY = 1700

var slide_speed_change
var SLIDE_SPEED
var player_sliding = false
var player_direction = 0
var health:int = 100 
var player_speed = WALK_SPEED

#I believe that beginning variables with underscore makes them private
@onready var _anim_manager = $AnimationManager
@onready var _anim_player = $AnimationManager/AnimationPlayer
@onready var _particle_manager = $"../ParticleManager"
@onready var _attack_collision = $"AttackHitbox/AttackCollison"

var ALL_ANIMATIONS = preload("res://PlayerAnimations.gd").ALL_ANIMATIONS

func _ready():
	Global.Player = self
	Global.PlayerX = global_position.x
	Global.PlayerY = global_position.y
	
	
func _physics_process(delta):
	Global.PlayerX = global_position.x
	Global.PlayerY = global_position.y
	checkForAttack(delta)
	push_other_bodies()
	particles_control()
	var inventory_is_on
	#is_inventory_on updater
	if(Input.is_action_just_pressed("inventory_toggle")):
		inventory_is_on = !inventory_is_on
	if !inventory_is_on:
		movement(delta)
	#NOT MOVING
	else:
		_anim_manager.change_animation(ALL_ANIMATIONS.RUN, false)
	
func movement(delta):
	if player_sliding:
		player_speed = SLIDE_SPEED
	elif Input.is_action_pressed("sprint"):
		player_speed = SPRINT_SPEED
	else:
		player_speed = WALK_SPEED
	if !player_sliding:
		player_direction = Input.get_axis("ui_left", "move-right")
	#GRAVITY
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	#JUMP
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -JUMP_VELOCITY
		_anim_manager.change_animation(ALL_ANIMATIONS.JUMP, true)
	#MOVING RIGHT
	if player_direction == 1:
		flip(true)
		_anim_manager.change_animation(ALL_ANIMATIONS.RUN, true)
	#MOVING LEFT
	elif player_direction == -1:
		flip(false)
		_anim_manager.change_animation(ALL_ANIMATIONS.RUN, true)
	#NOT MOVING
	else:
		_anim_manager.change_animation(ALL_ANIMATIONS.RUN, false)
		
		
	#GOOFY AH SLIDING SHIZ
	if Input.is_action_just_pressed("slide") && !player_sliding:
		player_sliding = true
		SLIDE_SPEED = player_speed
		slide()
	elif Input.is_action_just_pressed("slide") && player_sliding:
		player_sliding = false
	
	if !player_sliding:
		velocity.x = player_direction * player_speed
	else:
		velocity.x = player_direction * SLIDE_SPEED
	move_and_slide()
	check_change_in_y()
	
func check_change_in_y():
	var y1 = global_position.y
	var y2
	await get_tree().create_timer(0.01).timeout
	y2 = global_position.y
	if y1 - y2 < 0:
		return -1
	elif y1 - y2 > 0:
		return 1
	else:
		return 0

func slide():
	var floor_angle = get_floor_angle()
	var slow_or_speed
	var change_in_y = await check_change_in_y()
	if player_direction == 0:
		if get_floor_normal().x < 0:
			player_direction = -1
		elif get_floor_normal().x > 0:
			player_direction = 1
	while player_sliding == true && SLIDE_SPEED > 0:
		await get_tree().create_timer(0.001).timeout
		if get_floor_normal().x < 0:
			if player_direction == 1:
				slow_or_speed = -2
			elif player_direction == -1:
				slow_or_speed = 1
		elif get_floor_normal().x > 0:
			if player_direction == 1:
				slow_or_speed = 1
			elif player_direction == -1:
				slow_or_speed = -2
		else:
			slow_or_speed = 0
		if floor_angle == 0 && slow_or_speed == 0:
			slide_speed_change = -1
		else:
			slide_speed_change = floor_angle * slow_or_speed
		SLIDE_SPEED += slide_speed_change
	
	player_sliding = false
	print("end slide")

func push_other_bodies():
	#Pushing other bodies stuff
	for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			
			if collision && collision.get_collider() is RigidBody2D:
				collision.get_collider().apply_central_impulse(-collision.get_normal() * PUSH_FORCE)

var attacking = false

func checkForAttack(delta):
	if Input.is_action_just_pressed("attack"):
		attacking = true
		attack()

func attack():
	_anim_manager.change_animation(ALL_ANIMATIONS.ATTACK, true)
	
	#Before swipe time 
	await get_tree().create_timer(0.4).timeout
	_attack_collision.set_disabled(false)
	await get_tree().create_timer(0.1).timeout
	_attack_collision.set_disabled(true)

func die():
	get_tree().reload_current_scene()
	print("ouch")
	#whatever you wanna do when you die
	
	
func particles_control():
	if is_on_floor() && player_direction != 0:
		_particle_manager.set_particles_on(true)
	else:
		_particle_manager.set_particles_on(false)
		
		
func flip(isRight : bool):
	var nodes_to_flip = [
		$PlayerHitbox,
		$AttackHitbox,
		$AnimationManager,
		$HurtboxComponent
	]
	if isRight:
		for i in nodes_to_flip.size():
			nodes_to_flip[i].scale.x = 1
	if !isRight:
		for i in nodes_to_flip.size():
			nodes_to_flip[i].scale.x = -1
