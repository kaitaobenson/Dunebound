extends Node2D

enum ALL_ANIMATIONS {
	IDLE, 
	RUN, 
	ATTACK, 
	
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
	ALL_ANIMATIONS.SLIDE_END,
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
	make_sure_angle_right()
	
	for animation in animation_priority:
		if current_animations.has(animation):
			if playing_animation == animation:
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
			await get_tree().create_timer(0.001).timeout
			
		change_animation(ALL_ANIMATIONS.JUMP, false)
		
		
	if animationName == ALL_ANIMATIONS.SLIDE:
		playing_animation = ALL_ANIMATIONS.SLIDE
		_anim.play("SlideBegin")
		await _anim.animation_finished
		
		while current_animations.has(ALL_ANIMATIONS.SLIDE) && !current_animations.has(ALL_ANIMATIONS.JUMP):
			_anim.play("SlideLoop")
			if _player.is_on_floor_custom():
				_anim_sprite.rotation_degrees = _player.get_floor_angle_custom() * _player.player_sprite_direction
			else:
				_anim_sprite.rotation_degrees = 0
			await get_tree().create_timer(0.1).timeout
		_anim_sprite.rotation_degrees = 0
		
	if animationName == ALL_ANIMATIONS.SLIDE_END:
		playing_animation = ALL_ANIMATIONS.SLIDE_END
		_anim.play("SlideEnd")
		await _anim.animation_finished
		_anim_sprite.rotation_degrees = 0
		change_animation(ALL_ANIMATIONS.SLIDE_END, false)
		
		
func make_sure_angle_right():
	#uhh yeah
	if !current_animations.has(ALL_ANIMATIONS.SLIDE):
		_anim_sprite.rotation_degrees = 0
