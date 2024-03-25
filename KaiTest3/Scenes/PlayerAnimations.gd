extends Node2D

enum ALL_ANIMATIONS {
	IDLE, 
	RUN, 
	
	ATTACK, 
	SHORT_AD,
	SHORT_W,
	SHORT_S,
	LONG_AD,
	LONG_W,
	LONG_S,
	
	JUMP, 
	JUMP_UP, 
	JUMP_DOWN, 
	JUMP_LAND,
	
	SLIDE,
	SLIDE_BEGIN,
	SLIDE_LOOP,
	SLIDE_END,
	
	NONE
	}

var current_animations = [ALL_ANIMATIONS.IDLE]
var playing_animation : ALL_ANIMATIONS = ALL_ANIMATIONS.NONE

var animation_priority = [
	ALL_ANIMATIONS.ATTACK,
	ALL_ANIMATIONS.JUMP,
	ALL_ANIMATIONS.SLIDE,
	ALL_ANIMATIONS.RUN,
	ALL_ANIMATIONS.IDLE
]

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
	for animation in animation_priority:
		if current_animations.has(animation):
			if playing_animation == animation:
				var keys = ALL_ANIMATIONS.keys()
				break
			else:
				play_animation(animation)
				break
				
				
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
		
		while _player.is_on_floor_custom() == false:
			await get_tree().create_timer(0.1).timeout
		current_animations.erase(ALL_ANIMATIONS.JUMP)

		_anim.play("JumpLand")
		await _anim.animation_finished
		
		
	if animationName == ALL_ANIMATIONS.SLIDE:
		playing_animation = ALL_ANIMATIONS.SLIDE
		_anim.play("SlideBegin")
		await _anim.animation_finished
		_anim.play("SlideLoop")
		
		
		
	
