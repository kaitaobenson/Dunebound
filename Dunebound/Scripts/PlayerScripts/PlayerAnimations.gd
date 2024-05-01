extends Node2D

enum ALL_ANIMATIONS {
	IDLE, 
	RUN,
	
	SHORT_ATTACK_BEGIN_1,
	SHORT_ATTACK_END_1,
	
	LONG_ATTACK_BEGIN_1,
	LONG_ATTACK_END_1,
	
	JUMP, 
	JUMP_UP, 
	JUMP_DOWN, 
	#JUMP_LAND,
	
	SLIDE,
	SLIDE_BEGIN,
	SLIDE_LOOP,
	SLIDE_END,
	
	DEATH,
	
	NONE
	}

var current_animations = [ALL_ANIMATIONS.IDLE]
var playing_animation : ALL_ANIMATIONS = ALL_ANIMATIONS.NONE
var attack_type

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
	sprite_angle_0()
	var animation_with_highest_priority: ALL_ANIMATIONS
	var highest_priority: int = -1
	
	for animation in current_animations:
		var loop_priority = get_animation_priority(animation)
		if loop_priority > highest_priority:
			highest_priority = loop_priority
			animation_with_highest_priority = animation
			
	if animation_with_highest_priority != playing_animation:
		play_animation_sequence(animation_with_highest_priority)



func play_animation_sequence(animationName:ALL_ANIMATIONS):
	if animationName == ALL_ANIMATIONS.RUN:
		playing_animation = ALL_ANIMATIONS.RUN
		play_custom(ALL_ANIMATIONS.RUN)
		
		
	if animationName == ALL_ANIMATIONS.LONG_ATTACK_BEGIN_1:
		playing_animation = ALL_ANIMATIONS.LONG_ATTACK_BEGIN_1
		play_custom(ALL_ANIMATIONS.LONG_ATTACK_BEGIN_1)
		
	if animationName == ALL_ANIMATIONS.LONG_ATTACK_END_1:
		playing_animation = ALL_ANIMATIONS.LONG_ATTACK_END_1
		play_custom(ALL_ANIMATIONS.LONG_ATTACK_END_1)
		
		await _anim.animation_finished
		current_animations.erase(ALL_ANIMATIONS.LONG_ATTACK_BEGIN_1)
		current_animations.erase(ALL_ANIMATIONS.LONG_ATTACK_END_1)
	
	
	
	if animationName == ALL_ANIMATIONS.SHORT_ATTACK_BEGIN_1:
		playing_animation = ALL_ANIMATIONS.SHORT_ATTACK_BEGIN_1
		play_custom(ALL_ANIMATIONS.SHORT_ATTACK_BEGIN_1)
		
	if animationName == ALL_ANIMATIONS.SHORT_ATTACK_END_1:
		playing_animation = ALL_ANIMATIONS.SHORT_ATTACK_END_1
		play_custom(ALL_ANIMATIONS.SHORT_ATTACK_END_1)
		
		await _anim.animation_finished
		current_animations.erase(ALL_ANIMATIONS.SHORT_ATTACK_BEGIN_1)
		current_animations.erase(ALL_ANIMATIONS.SHORT_ATTACK_END_1)
		
	if animationName == ALL_ANIMATIONS.IDLE:
		playing_animation = ALL_ANIMATIONS.IDLE
		play_custom(ALL_ANIMATIONS.IDLE)
		
		
	if animationName == ALL_ANIMATIONS.JUMP:
		playing_animation = ALL_ANIMATIONS.JUMP
		play_custom(ALL_ANIMATIONS.JUMP_UP)
		
		while _player.velocity.y <= 0:
			await get_tree().process_frame
		play_custom(ALL_ANIMATIONS.JUMP_DOWN)
		
		while _player.is_on_floor_custom() == false:
				await get_tree().process_frame
			
		change_animation(ALL_ANIMATIONS.JUMP, false)
		
		
	if animationName == ALL_ANIMATIONS.SLIDE:
		playing_animation = ALL_ANIMATIONS.SLIDE
		play_custom(ALL_ANIMATIONS.SLIDE_BEGIN)
		await _anim.animation_finished
		
		while current_animations.has(ALL_ANIMATIONS.SLIDE) && !current_animations.has(ALL_ANIMATIONS.JUMP):
			play_custom(ALL_ANIMATIONS.SLIDE_LOOP)
			if _player.is_on_floor_custom():
				_anim_sprite.rotation_degrees = _player.get_floor_angle_custom() * _player.player_sprite_direction
			else:
				_anim_sprite.rotation_degrees = 0
			await get_tree().process_frame
		_anim_sprite.rotation_degrees = 0
		
		
	if animationName == ALL_ANIMATIONS.SLIDE_END:
		playing_animation = ALL_ANIMATIONS.SLIDE_END
		play_custom(ALL_ANIMATIONS.SLIDE_END)
		await _anim.animation_finished
		_anim_sprite.rotation_degrees = 0
		change_animation(ALL_ANIMATIONS.SLIDE_END, false)
		
		
	if animationName == ALL_ANIMATIONS.DEATH:
		playing_animation = ALL_ANIMATIONS.DEATH
		play_custom(ALL_ANIMATIONS.DEATH)



func sprite_angle_0():
	if !current_animations.has(ALL_ANIMATIONS.SLIDE):
		_anim_sprite.rotation_degrees = 0



func play_custom(animation: ALL_ANIMATIONS):
	var first_animation_priority = get_animation_priority(animation)
	for animation1 in current_animations:
		var loop_animation_priority = get_animation_priority(animation1)
		if loop_animation_priority > first_animation_priority:
			return
	var animation_string: String = ALL_ANIMATIONS.keys()[animation]
	_anim.play(animation_string.to_pascal_case())



func get_animation_priority(animation: ALL_ANIMATIONS) -> int:
	var animation_priority = [
		ALL_ANIMATIONS.IDLE,
		ALL_ANIMATIONS.RUN,
		ALL_ANIMATIONS.SLIDE,
		ALL_ANIMATIONS.SLIDE_BEGIN,
		ALL_ANIMATIONS.SLIDE_LOOP,
		ALL_ANIMATIONS.SLIDE_END,
		ALL_ANIMATIONS.JUMP,
		ALL_ANIMATIONS.JUMP_UP,
		ALL_ANIMATIONS.JUMP_DOWN,
		
		ALL_ANIMATIONS.SHORT_ATTACK_BEGIN_1,
		ALL_ANIMATIONS.SHORT_ATTACK_END_1,
		ALL_ANIMATIONS.LONG_ATTACK_BEGIN_1,
		ALL_ANIMATIONS.LONG_ATTACK_END_1,
		
		ALL_ANIMATIONS.DEATH
	]
	
	return animation_priority.find(animation)
