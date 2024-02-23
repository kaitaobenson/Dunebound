extends CharacterBody2D

# Important for camera, don't remove from class level
var direction = 0

@onready var invon = false
@onready var anim = $AnimationPlayer

var health:int = 100

func _ready():
	Global.PlayerX = global_position.x
	Global.PlayerY = global_position.y
	
	
func _physics_process(delta):
	Global.PlayerX = global_position.x
	Global.PlayerY = global_position.y
	Global.PlayerPosition = global_position
	movement(delta)
	checkForAttack(delta)
	
func movement(delta):
	
	var SPEED = get_meta("SPEED")
	var JUMP_VELOCITY = get_meta("JUMP")
	var gravity = get_meta("GRAVITY");
	direction = Input.get_axis("ui_left", "move-right")
	
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and !invon:
		velocity.y = -JUMP_VELOCITY
	
	#Moving Right
	if direction == 1 && invon == false:
		$AnimatedSprite2D.scale.x = 1
		animation("RUN")
	#Moving Left
	elif direction == -1 && invon == false:
		$AnimatedSprite2D.scale.x = -1
		animation("RUN")
	#Not moving
	else:
		animation("IDLE")
	
	# No movement while open inventory
	if invon == false:
		velocity.x = direction * SPEED
		$"../States".start_state("particles")
	else: 
		velocity.x = 0
	#invon updater
	if(Input.is_action_just_pressed("inventory_toggle")):
		invon = !invon
	
	move_and_slide()

var attacking = false

func checkForAttack(delta):
	if Input.is_action_just_pressed("attack"):
		attacking = true
		attack()

func attack():
	var attackHitbox = $"AnimatedSprite2D/AttackHitbox/CollisionShape2D"
	animation("ATTACK")
	attackHitbox.set_disabled(false)
	
	await anim.animation_finished
	animation("STOP")
	attackHitbox.set_disabled(true)
	

var currentAnimation = "IDLE"

func animation(animationName):
	#RUN
	if animationName == "RUN" && currentAnimation != "ATTACK":
		if currentAnimation != "RUN":
			anim.stop()
		anim.play("Run")
		currentAnimation = "RUN"
	#IDLE
	elif animationName == "IDLE" && currentAnimation != "ATTACK":
		if currentAnimation != "IDLE":
			anim.stop()
		anim.play("Idle")
		currentAnimation = "IDLE"
	#Attack1
	elif animationName == "ATTACK":
		if currentAnimation != "ATTACK":
			anim.stop() 
		anim.play("Slash1")
		currentAnimation = "ATTACK"
	#STOP
	elif animationName == "STOP":
		anim.stop()
		currentAnimation = "STOP"

func doDamage(damage:int):
	health = health - damage
	if(health<=0):
		die()
		
func die():
	get_tree().reload_current_scene()
	#whatever you wanna do when you die


func out_of_world(body):
	die()


func _attack_hitbox_body_entered(body):
	var attackDamage = 10
	if body.is_in_group("Hurtbox"):
		#All bodies with a hurtbox should have this method!
		#Is there a way to enforce this?  idk
		body.take_damage(attackDamage)
