extends Node2D

enum ALL_ANIMATIONS {
	IDLE, 
	RUN, 
	ATTACK, 
	JUMP, 
	JUMP_UP, 
	JUMP_DOWN, 
	JUMP_LAND,
	NONE
	}

var current_animations = [ALL_ANIMATIONS.IDLE]
var playing_animation : ALL_ANIMATIONS = ALL_ANIMATIONS.NONE

var jump = 0

@onready var _anim = $AnimationPlayer
@onready var _anim_sprite = $AnimatedSprite2D
@onready var _player = $"../"


func change_animation(name:ALL_ANIMATIONS, isOn:bool):
	if isOn:
		if current_animations.has(name) == false:
			current_animations.append(name)
	else:
		if current_animations.has(name) == true:
			current_animations.erase(name)
			
			
			
func _process(delta):
	if current_animations.has(ALL_ANIMATIONS.ATTACK):
		if playing_animation != ALL_ANIMATIONS.ATTACK:
			play_animation(ALL_ANIMATIONS.ATTACK)
			print("ATTACK")
		
	elif current_animations.has(ALL_ANIMATIONS.JUMP):
		if playing_animation != ALL_ANIMATIONS.JUMP:
			print("JUMP")
			play_animation(ALL_ANIMATIONS.JUMP)
		
	elif current_animations.has(ALL_ANIMATIONS.RUN):
		if playing_animation != ALL_ANIMATIONS.RUN:
			play_animation(ALL_ANIMATIONS.RUN)
			print("RUN")
			
	elif current_animations.has(ALL_ANIMATIONS.IDLE):
		if playing_animation != ALL_ANIMATIONS.IDLE:
			play_animation(ALL_ANIMATIONS.IDLE)
			print("IDLE")
			
			
			
func play_animation(animationName:ALL_ANIMATIONS):
	if animationName == ALL_ANIMATIONS.RUN:
		_anim.play("Run")
		playing_animation = ALL_ANIMATIONS.RUN
		
		
	if animationName == ALL_ANIMATIONS.ATTACK:
		_anim.play("Slash1")
		playing_animation = ALL_ANIMATIONS.ATTACK
		
		await _anim.animation_finished
		current_animations.erase(ALL_ANIMATIONS.ATTACK)
		
		
	if animationName == ALL_ANIMATIONS.IDLE:
		_anim.play("Idle")
		playing_animation = ALL_ANIMATIONS.IDLE
		
		
	if animationName == ALL_ANIMATIONS.JUMP:
		playing_animation = ALL_ANIMATIONS.JUMP
		_anim.play("JumpUp")
		
		while _player.velocity.y <= 0:
			await get_tree().create_timer(0.1).timeout
		_anim.play("JumpDown")
		
		while _player.is_on_floor() == false:
			await get_tree().create_timer(0.1).timeout
		_anim.play("JumpLand")
		
		await _anim.animation_finished
		current_animations.erase(ALL_ANIMATIONS.JUMP)
