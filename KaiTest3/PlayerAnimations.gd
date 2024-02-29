extends Node2D

enum ALL_ANIMATIONS {IDLE, RUN, ATTACK, JUMP, JUMP_UP, JUMP_DOWN, JUMP_LAND}

var current_animations = [ALL_ANIMATIONS.IDLE]
var playing_animation

var jump = 0

@onready var _anim = $AnimationPlayer
@onready var _anim_sprite = $AnimatedSprite2D
@onready var _player = $"../"

func _process(delta):
	if current_animations.has(ALL_ANIMATIONS.ATTACK):
		play_animation(ALL_ANIMATIONS.ATTACK)
		
	elif current_animations.has(ALL_ANIMATIONS.JUMP):
		play_animation(ALL_ANIMATIONS.JUMP)
		
	elif current_animations.has(ALL_ANIMATIONS.RUN):
		play_animation(ALL_ANIMATIONS.RUN)
		
	elif current_animations.has(ALL_ANIMATIONS.IDLE):
		play_animation(ALL_ANIMATIONS.IDLE)
		print("plaing idle")
		
		
func change_animation(name:ALL_ANIMATIONS, isOn:bool):
	if isOn:
		if current_animations.has(name) == false:
			current_animations.append(name)
	else:
		if current_animations.has(name) == true:
			current_animations.erase(name)
			
			
			
func play_animation(animationName:ALL_ANIMATIONS):
	#RUN
	if animationName == ALL_ANIMATIONS.RUN && playing_animation != ALL_ANIMATIONS.RUN:
		stop_animation_if_not_playing(ALL_ANIMATIONS.RUN)
		_anim.play("Run")
		playing_animation = ALL_ANIMATIONS.RUN
		
	#ATTACK
	if animationName == ALL_ANIMATIONS.ATTACK && playing_animation != ALL_ANIMATIONS.ATTACK:
		stop_animation_if_not_playing(ALL_ANIMATIONS.ATTACK)
		_anim.play("Slash1")
		playing_animation = ALL_ANIMATIONS.ATTACK
		
	#IDLE
	if animationName == ALL_ANIMATIONS.IDLE && playing_animation != ALL_ANIMATIONS.IDLE:
		print("iDEL")
		stop_animation_if_not_playing(ALL_ANIMATIONS.IDLE)
		_anim.play("Idle")
		playing_animation = ALL_ANIMATIONS.IDLE
		
	#JUMP
	if animationName == ALL_ANIMATIONS.JUMP:
		if jump == 0:
			stop_animation_if_not_playing(ALL_ANIMATIONS.JUMP_UP)
			playing_animation = ALL_ANIMATIONS.JUMP
			_anim.play("JumpUp")
			if _player.velocity.y > 0:
				jump = 1
				
		if jump == 1:
			stop_animation_if_not_playing(ALL_ANIMATIONS.JUMP_DOWN)
			_anim.play("JumpDown")
			if _player.is_on_floor():
				jump = 2
				
		if jump == 2:
			stop_animation_if_not_playing(ALL_ANIMATIONS.JUMP_LAND)
			_anim.play("JumpLand")
			await get_tree().create_timer(0.1).timeout
			
			current_animations.erase(ALL_ANIMATIONS.JUMP)
			jump = 0 
			
			
			
func stop_animation_if_not_playing(animation : ALL_ANIMATIONS):
	if playing_animation != animation:
		_anim.stop()
