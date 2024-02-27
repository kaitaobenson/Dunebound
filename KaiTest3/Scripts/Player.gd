extends CharacterBody2D

const PUSH_FORCE = 1000
const SPEED = 300
const JUMP_VELOCITY = 600
const GRAVITY = 1000

var current_animations = ["IDLE"]
var player_direction = 0
var health:int = 100 


#I believe that beginning variables with underscore makes them private
@onready var _anim_manager = $AnimationManager
@onready var _anim_sprite = $AnimationManager/AnimatedSprite2D
@onready var _particle_manager = $"../ParticleManager"

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
	player_direction = Input.get_axis("ui_left", "move-right")
	#GRAVITY
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	#JUMP
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -JUMP_VELOCITY
	#MOVING RIGHT
	if player_direction == 1:
		_anim_manager.flip_sprite(true)
		_anim_manager.change_animation(ALL_ANIMATIONS.RUN, true)
	#MOVING LEFT
	elif player_direction == -1:
		_anim_manager.flip_sprite(false)
		_anim_manager.change_animation(ALL_ANIMATIONS.RUN, true)
	#NOT MOVING
	else:
		_anim_manager.change_animation(ALL_ANIMATIONS.RUN, false)
		
	
	
	velocity.x = player_direction * SPEED
	move_and_slide()
	
	
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

	var attackHitbox = get_node("AttackHitbox/CollisionShape2D")
	
	_anim_manager.change_animation(ALL_ANIMATIONS.ATTACK, true) 
	attackHitbox.set_disabled(false)
	
	await _anim_sprite.animation_finished
	
	attackHitbox.set_disabled(true)

func die():
	get_tree().reload_current_scene()
	print("ouch")
	#whatever you wanna do when you die

func out_of_world(body):
	if body.name == "Player":
		die()

func _attack_hitbox_body_entered(body):
	var attackDamage = 10
	if body.is_in_group("Hurtbox"):
		#All bodies with a hurtbox should have this method!
		#Is there a way to enforce this?  idk
		body.take_damage(attackDamage)
		
		
func particles_control():
	if is_on_floor() && player_direction != 0:
		_particle_manager.set_particles_on(true)
	else:
		_particle_manager.set_particles_on(false)
