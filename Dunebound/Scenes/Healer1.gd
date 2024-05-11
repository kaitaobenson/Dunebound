extends Node2D

@onready var glow = $"Glow"
var grow_speed: int = 1

var previous_grow_done: bool = true

func _process(delta):
	if previous_grow_done:
		previous_grow_done = false
		
		get_tree().create_tween().tween_property(glow, "scale", Vector2(2,2), grow_speed)
		await get_tree().create_timer(grow_speed).timeout
		get_tree().create_tween().tween_property(glow, "scale", Vector2(1,1), grow_speed)
		await get_tree().create_timer(grow_speed).timeout
		
		previous_grow_done = true
