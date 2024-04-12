extends Node

const MIN_SPEED = 350
const MAX_SPEED = 1200

const SLIDE_SPEED_MULTIPLIER = 6.9
const SLIDE_DRAG = 80

const DASH_TIME = 0.13
const DASH_SPEED = 600

var previous_slide_done: bool = true
var slide_is_pressed: bool = false
var slide_has_moved: bool = false

var move_is_locked: bool = false
var jump_is_locked: bool = false

var can_stop_slide: bool = false

var sliding_in_air: bool = false

@onready var _player = $"../"
@onready var _anim_manager = $"../AnimationManager/"

func _process(delta):
	if Input.is_action_just_pressed("slide"):
		slide_is_pressed = true
	if Input.is_action_just_released("slide"):
		slide_is_pressed = false


func _physics_process(delta):
	if !Input.is_action_pressed("jump"):
		handle_slide()


func handle_slide():
	if slide_is_pressed && _player.is_on_floor() && previous_slide_done:
		### SLIDE, TRIGGERED ONCE ###
		previous_slide_done = false
		
		_anim_manager.change_animation(_anim_manager.ALL_ANIMATIONS.SLIDE, true)
		jump_is_locked = true
		move_is_locked = true
		_player.gravity = _player.SLIDING_GRAVITY
		
		await dash()
		jump_is_locked = false
		
		slide_has_moved = true
		sliding_in_air = false
		
		await slide()
		slide_is_pressed = false
		
		can_stop_slide = true
		previous_slide_done = true
		move_is_locked = false
		
		_player.gravity = _player.NORMAL_GRAVITY
		
		
	if ((!slide_is_pressed && !move_is_locked) || previous_slide_done) && can_stop_slide:
		### STOP SLIDE, TRIGGERED ONCE ###
		can_stop_slide = false
		_anim_manager.change_animation(_anim_manager.ALL_ANIMATIONS.SLIDE, false)
		if !sliding_in_air:
			_anim_manager.change_animation(_anim_manager.ALL_ANIMATIONS.SLIDE_END, true)
		_player.gravity = _player.NORMAL_GRAVITY


func dash():
	var timer = get_tree().create_timer(DASH_TIME)
	
	while timer.time_left > 0:
		_player.velocity.x = DASH_SPEED * _player.player_sprite_direction
		await get_tree().create_timer(0.001).timeout
	
	await get_tree().create_timer(0.5).timeout
	return


func slide():
	var floor_angle = rad_to_deg(atan2(_player.get_floor_normal().y, _player.get_floor_normal().x)) + 90
	var new_speed = (_player.velocity.x) + (floor_angle * SLIDE_SPEED_MULTIPLIER) - (SLIDE_DRAG)
	
	while slide_is_pressed && slide_has_moved && _player.is_on_floor_custom() && ((_player.player_sprite_direction > 0 && new_speed > 0) || (_player.player_sprite_direction < 0 && new_speed < 0)):
		floor_angle = rad_to_deg(atan2(_player.get_floor_normal().y, _player.get_floor_normal().x)) + 90
		new_speed += (floor_angle * SLIDE_SPEED_MULTIPLIER) - (SLIDE_DRAG * _player.player_sprite_direction)
		if new_speed > MAX_SPEED:
			new_speed = MAX_SPEED
		if _player.is_on_floor() && ((_player.player_sprite_direction > 0 && new_speed > 0) || (_player.player_sprite_direction < 0 && new_speed < 0)):
			_player.velocity.x = new_speed
		
		slide_has_moved = await check_if_moved()
		await get_tree().create_timer(0.001).timeout
		
	while slide_is_pressed && !_player.is_on_floor_custom():
		sliding_in_air = true
		
		if _player.is_on_floor() && ((_player.player_sprite_direction > 0 && new_speed > 0) || (_player.player_sprite_direction < 0 && new_speed < 0)):
			_player.velocity.x = new_speed
		
		slide_has_moved = await check_if_moved()
		await get_tree().create_timer(0.001).timeout



func check_if_moved() -> bool:
	var first_pos: Vector2 = _player.position
	var second_pos: Vector2
	await get_tree().create_timer(0.1).timeout
	second_pos = _player.position
	
	if first_pos.distance_squared_to(second_pos) >= 0.01:
		return true
	else:
		return false


func is_move_locked() -> bool:
	return move_is_locked

func is_jump_locked() -> bool:
	return jump_is_locked

func is_sliding() -> bool:
	return !previous_slide_done
