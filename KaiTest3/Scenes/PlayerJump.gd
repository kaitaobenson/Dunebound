extends Node

const JUMP_VELOCITY = 800

var player_can_jump = true

var _jump_timer = 0.0
var _coyote_can_jump = false
var _coyote_time = 0.2

var ALL_ANIMATIONS = preload("res://PlayerAnimations.gd").ALL_ANIMATIONS

@onready var _player = $"../"
@onready var _anim_manager = $"../AnimationManager" 

func _process(delta) -> void:
	if _player.is_on_floor_custom():
		_coyote_can_jump = true
		_jump_timer = 0.0
	else:
		_jump_timer += delta
		if _jump_timer < _coyote_time:
			_coyote_can_jump = true
		else:
			_coyote_can_jump = false
			
	if Input.is_action_just_pressed("jump") && _coyote_can_jump && player_can_jump:
		jump()
		while _player.is_on_floor_custom():
			await get_tree().create_timer(0.1).timeout
		_jump_timer = 100.0
		
		
func jump() -> void:
	_player.velocity.y = -JUMP_VELOCITY
	_anim_manager.change_animation(ALL_ANIMATIONS.JUMP, true)
	
	
func set_can_jump(can_jump: bool) -> void:
	player_can_jump = can_jump
	
func get_can_jump() -> bool:
	return player_can_jump
