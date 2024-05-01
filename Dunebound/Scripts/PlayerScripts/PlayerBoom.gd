extends Node2D

@onready var circle = $"Circle"
@onready var line = $"Line"

func _ready():
	visible = true
	circle.scale = Vector2(0,0)
	line.scale = Vector2(0,0)

func do_boom():
	circle.scale = Vector2(0,0)
	circle.modulate.a = 0
	line.scale = Vector2(0,0)
	line.modulate.a = 0
	rotation_degrees = randf_range(45, -45)
	
	get_tree().create_tween().tween_property(circle, "scale", Vector2(1,1), 0.04).set_trans(Tween.TRANS_EXPO)
	get_tree().create_tween().tween_property(circle, "modulate:a", 0.7, 0.5).set_trans(Tween.TRANS_EXPO)
	
	await get_tree().create_timer(0.2).timeout
	get_tree().create_tween().tween_property(line, "scale", Vector2(1, 1), 0.1).set_trans(Tween.TRANS_CUBIC)
	get_tree().create_tween().tween_property(line, "modulate:a", 0.9, 0.2).set_trans(Tween.TRANS_EXPO)

	
	await get_tree().create_timer(0.4).timeout
	get_tree().create_tween().tween_property(circle, "scale", Vector2(0,0), 0.3).set_trans(Tween.TRANS_LINEAR)
	get_tree().create_tween().tween_property(circle, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR)
	
	get_tree().create_tween().tween_property(line, "scale", Vector2(1,0), 0.3).set_trans(Tween.TRANS_LINEAR)
	get_tree().create_tween().tween_property(line, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR)
