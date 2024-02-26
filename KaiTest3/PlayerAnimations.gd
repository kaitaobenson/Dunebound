extends Node2D

enum ALL_ANIMATIONS {IDLE, RUN, ATTACK}

var current_animations = [ALL_ANIMATIONS.IDLE]
var playing_animation

@onready var _anim = $AnimationPlayer
@onready var _anim_sprite = $AnimatedSprite2D

func _process(delta):
	if current_animations.has(ALL_ANIMATIONS.ATTACK):
		play_animation(ALL_ANIMATIONS.ATTACK)
		
	elif current_animations.has(ALL_ANIMATIONS.RUN):
		play_animation(ALL_ANIMATIONS.RUN)
		
	elif current_animations.has(ALL_ANIMATIONS.IDLE):
		play_animation(ALL_ANIMATIONS.IDLE)
		
		
		
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
		if playing_animation != ALL_ANIMATIONS.RUN:
			_anim.stop()
		_anim.play("Run")
		playing_animation = ALL_ANIMATIONS.RUN
		
	#ATTACK
	if animationName == ALL_ANIMATIONS.ATTACK && playing_animation != ALL_ANIMATIONS.ATTACK:
		if playing_animation != ALL_ANIMATIONS.ATTACK:
			_anim.stop() 
		_anim.play("Slash1")
		playing_animation = ALL_ANIMATIONS.ATTACK
		
	#IDLE
	if animationName == ALL_ANIMATIONS.IDLE && playing_animation != ALL_ANIMATIONS.IDLE:
		if playing_animation != ALL_ANIMATIONS.IDLE:
			_anim.stop()
		
		_anim.play("Idle")
		playing_animation = ALL_ANIMATIONS.IDLE
		
		
func flip_sprite(isRight:bool):
	if isRight:
		_anim_sprite.scale.x = 1
	if !isRight:
		_anim_sprite.scale.x = -1
