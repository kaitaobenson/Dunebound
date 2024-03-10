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

var _attack_cooldown_over = true

var _jump_timer = 0.0
var _can_jump = false
var _coyote_time = 0.2

#I believe that beginning variables with underscore makes them private
@onready var _anim_manager = $AnimationManager
@onready var _anim_player = $AnimationManager/AnimationPlayer
@onready var _particle_manager = $"../ParticleManager"
@onready var _attack_collision = $"AttackHitbox/AttackCollison"

var ALL_ANIMATIONS = preload("res://PlayerAnimations.gd").ALL_ANIMATIONS

func _ready():
	Global.Player = self
	
func _physics_process(delta):
	push_other_bodies()
	particles_control()
	var inventory_is_on
	#is_inventory_on updater
	if(Input.is_action_just_pressed("inventory_toggle")):
		inventory_is_on = !inventory_is_on
	
	apply_gravity(delta)
	
	if Input.is_action_just_pressed("slide") && !player_sliding && is_on_floor_custom():
		player_sliding = true
		SLIDE_SPEED = player_speed
		slide()
	elif Input.is_action_just_pressed("slide") && player_sliding:
		player_sliding = false
	
	### AD MOVEMENT ###
	player_direction = Input.get_axis("ui_left", "move-right")
	wasd_movement(player_direction)
	
	print(is_on_floor_custom())
	### JUMP ###
	if is_on_floor_custom():
		print("onfloor")
		_can_jump = true
		_jump_timer = 0.0
	else:
		print("notonfloor")
		_jump_timer += delta
		if _jump_timer < _coyote_time:
			_can_jump = true
		else:
			_can_jump = false
			
	if Input.is_action_just_pressed("ui_accept") && _can_jump:
		jump()
		while is_on_floor_custom():
			await get_tree().create_timer(0.1).timeout
		_jump_timer = 100.0
		print("jumptimerset")
		
	### ATTACK ###
	if Input.is_action_just_pressed("attack") && _attack_cooldown_over:
		attack()
		_attack_cooldown_over = false
		
		var timer = get_tree().create_timer(1)
		while timer.time_left != 0:
			await get_tree().create_timer(0.1).timeout
			
		_attack_cooldown_over = true
	
	
func wasd_movement(direction : int):
	if direction > 0:
		#direction = 1
		flip(true)
		_anim_manager.change_animation(ALL_ANIMATIONS.RUN, true)
		velocity.x = 1 * player_speed
		
	elif direction < 0:
		#direction = -1
		flip(false)
		_anim_manager.change_animation(ALL_ANIMATIONS.RUN, true)
		velocity.x = -1 * player_speed 
		
	else:
		# direction = 0
		_anim_manager.change_animation(ALL_ANIMATIONS.RUN, false)
		velocity.x = 0
		
	move_and_slide()
	
	
func jump():
	velocity.y = -JUMP_VELOCITY
	
	
func apply_gravity(delta):
	if not is_on_floor_custom():
		velocity.y += GRAVITY * delta
	
	
func check_change_in_x():
	var x1 = global_position.x
	var x2
	await get_tree().create_timer(.001).timeout
	x2 = global_position.x
	return x1 - x2

func slide():
	#For sliding from stationary
	if player_direction == 0:
		SLIDE_SPEED = 50
		if get_floor_normal().x < 0:
			player_direction = -1
		elif get_floor_normal().x > 0:
			player_direction = 1
	while player_sliding == true && SLIDE_SPEED > -0.1:
		#print(player_direction)
		var floor_angle = get_floor_angle()
		var slow_or_speed
		var change_in_x = await check_change_in_x()
		await get_tree().create_timer(0.001).timeout
		if get_floor_normal().x < 0:
			if player_direction == 1:
				slow_or_speed = -3
				print(1)
			elif player_direction == -1:
				slow_or_speed = 3
				print(2)
		elif get_floor_normal().x > 0:
			if player_direction == 1:
				slow_or_speed = 3
				print(3)
			elif player_direction == -1:
				slow_or_speed = -3
				print(4)
		else:
			slow_or_speed = 0
		slide_speed_change = floor_angle * (abs(floor_angle) + 1) * slow_or_speed
		if slide_speed_change > 0:
			slide_speed_change += 1
		else:
			slide_speed_change -= 1
		if floor_angle == 0:
			slide_speed_change = -2
		SLIDE_SPEED += slide_speed_change
	
	player_sliding = false
	print("end slide")

func push_other_bodies():
	for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			
			if collision && collision.get_collider() is RigidBody2D:
				collision.get_collider().apply_central_impulse(-collision.get_normal() * PUSH_FORCE)

func attack():
	_anim_manager.change_animation(ALL_ANIMATIONS.ATTACK, true)
	
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
			
			
func is_on_floor_custom() -> bool:
	var left = $GroundRaycasts/Left
	var center = $GroundRaycasts/Center
	var right = $GroundRaycasts/Right
	
	if left.is_colliding() || center.is_colliding() || right.is_colliding():
		return true
	else: 
		return false
