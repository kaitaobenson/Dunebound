extends Node2D

var _is_on: bool = true
var _can_tween = true
var _default_position: Vector2

@export var _sprite: Sprite2D

func _ready():
	_default_position = self.position

func _process(delta):
	if _is_on && _can_tween:
		_sprite.visible = true
		
		_can_tween = false
		
		var tween1 = get_tree().create_tween()
		tween1.tween_property(_sprite, "position", Vector2(0,-5), 1)
		
		await get_tree().create_timer(1).timeout
		
		var tween2 = get_tree().create_tween()
		tween2.tween_property(_sprite, "position", Vector2(0, 5), 1)
		
		await get_tree().create_timer(1).timeout
		
		_can_tween = true
		
	if !_is_on:
		_sprite.visible = false
		position = _default_position
		
		_can_tween = true


func turn_on():
	_is_on = true
func turn_off():
	_is_on = false
func get_status() -> bool:
	return _is_on
