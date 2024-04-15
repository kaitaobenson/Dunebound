extends CharacterBody2D

const PUSH_FORCE = 100
const JUMP_VELOCITY = 900

const WALK_SPEED = 380
const SPRINT_SPEED = 600
var player_speed = WALK_SPEED

const NORMAL_GRAVITY = 2000
const SLIDING_GRAVITY = 9000
var gravity: int = NORMAL_GRAVITY
var foodPickup 
#1, 0, -1
var player_movement_direction: int = 0
#1, -1
var player_sprite_direction: int = 1

var health: int = 100 
var is_dead: bool = false

var _jump_timer = 0.0
var _can_jump = false
var _coyote_time = 0.2


@onready var _anim_manager = $AnimationManager
@onready var _particle_manager = $"../ParticleManager"
@onready var _attack_manager = $"AttackManager"
@onready var _audio_manager = $"AudioManager"

@onready var _slide = $"Slide/"
@onready var _hitbox = $"PlayerHitbox"

func _init():
	Global.Player = self

func _ready():
	Global.saver_loader.find_saved_value("Health")
	global_position = Global.saver_loader.find_saved_value("PlayerPos")


func _physics_process(delta):
	
	if(Input.is_action_just_pressed("interact")&&foodPickup is Object):
		Global.inventory.newInfoGhost(foodPickup)
		foodPickup.queue_free()
		
	move_and_slide()
	push_other_bodies()
	var inventory_is_on
	#is_inventory_on updater
	if(Input.is_action_just_pressed("inventory_toggle")):
		inventory_is_on = !inventory_is_on
	apply_gravity(delta)
	
	### AD MOVEMENT ###
	player_movement_direction = Input.get_axis("move_left", "move_right")
	if player_movement_direction != 0 && (!_slide.is_move_locked() && !_attack_manager.is_move_locked() && !is_dead):
		if player_movement_direction != 0:
			ad_movement(player_movement_direction)
			_audio_manager.play(_audio_manager.ALL_SOUNDS.FOOTSTEPS)
			
	elif !_slide.is_sliding():
		velocity.x = lerp(velocity.x, 0.0, 0.2)
		_anim_manager.change_animation(_anim_manager.ALL_ANIMATIONS.RUN, false)
		_audio_manager.stop(_audio_manager.ALL_SOUNDS.FOOTSTEPS)
	
	### JUMP ###
	if is_on_floor_custom():
		_can_jump = true
		_jump_timer = 0.0
	else:
		_jump_timer += delta
		if _jump_timer < _coyote_time:
			_can_jump = true
		else:
			_can_jump = false
			
			
	if Input.is_action_just_pressed("jump") && _can_jump && !_slide.is_jump_locked() && !_attack_manager.is_jump_locked() && !is_dead:
		jump()
		while is_on_floor_custom() && !is_dead:
			await get_tree().process_frame
		_jump_timer = 100.0


func ad_movement(direction: int) -> void:
	if direction != 0:
		_anim_manager.change_animation(_anim_manager.ALL_ANIMATIONS.RUN, true)
	else:
		_anim_manager.change_animation(_anim_manager.ALL_ANIMATIONS.RUN, false)
	
	if direction > 0:
		flip(true)
	elif direction < 0:
		flip(false)
	velocity.x = direction * player_speed


func jump():
	_audio_manager.play(_audio_manager.ALL_SOUNDS.JUMP)
	velocity.y = -JUMP_VELOCITY
	_anim_manager.change_animation(_anim_manager.ALL_ANIMATIONS.JUMP, true)


func apply_gravity(delta):
	if !is_on_floor_custom():
		gravity = NORMAL_GRAVITY
	velocity.y += gravity * delta


func push_other_bodies():
	for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			
			if collision && collision.get_collider() is RigidBody2D:
				collision.get_collider().apply_central_impulse(-collision.get_normal() * PUSH_FORCE)


func die():
	if !is_dead:
		is_dead = true
		_anim_manager.change_animation(_anim_manager.ALL_ANIMATIONS.DEATH, true)
		
		await get_tree().create_timer(1).timeout
		set_physics_process(false)
		set_process(false)
		for child in get_children():
			child.set_physics_process(false)
			child.set_process(false)
		_hitbox.disabled = true
		await get_tree().create_timer(1).timeout
		get_tree().reload_current_scene()

func flip(isRight : bool):
	var nodes_to_flip = [
		$PlayerHitbox,
		$AttackManager,
		$AnimationManager,
		$HurtboxComponent
	]
	if isRight:
		player_sprite_direction = 1
		for i in nodes_to_flip.size():
			nodes_to_flip[i].scale.x = 1
	if !isRight:
		player_sprite_direction = -1
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


var floor_angle = 0
func get_floor_angle_custom() -> float:
	if is_on_floor():
		floor_angle = rad_to_deg(atan2(get_floor_normal().y, get_floor_normal().x)) + 90
	return floor_angle
