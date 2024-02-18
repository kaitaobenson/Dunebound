extends CharacterBody2D

# Important for camera, don't remove from class level
var direction = 0

@onready var invon = false
@onready var anim = $AnimationPlayer
@onready var animSprite = $AnimatedSprite2D

var swingCircle:Array
var health:int = 100

func _ready():
	Global.PlayerX = global_position.x
	Global.PlayerY = global_position.y
	
func _process(delta):
	animation()
	
func _physics_process(delta):
	Global.PlayerX = global_position.x
	Global.PlayerY = global_position.y
	Global.PlayerPosition = global_position
	movement(delta)
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
	
	# Right
	if direction == 1:
		if invon == false:
			animSprite.flip_h = false
	# Left
	if direction == -1:
		if invon == false:
			animSprite.flip_h = true
	# No movement while open inventory
	if invon == false:
		velocity.x = direction * SPEED
		$"../States".start_state("particles")
	else: velocity.x = 0
	#invon updater
	if(Input.is_action_just_pressed("inventory_toggle")):
		invon = !invon
	
	move_and_slide()


var currentAnimation = "IDLE"

func animation():
	
	if velocity.x != 0:
		if currentAnimation != "RUN":
			anim.stop()
		anim.play("Run")
		currentAnimation = "RUN"
		
	if velocity.x == 0 && velocity.y == 0:
		if currentAnimation != "IDLE":
			anim.stop()
		anim.play("Idle")
		currentAnimation = "IDLE"
		

func doDamage(damage:int):
	health = health - damage
	if(health<=0):
		die()
		
func die():
	get_tree().reload_current_scene()
	#whatever you wanna do when you die
