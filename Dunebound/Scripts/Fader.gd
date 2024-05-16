extends Node2D

@onready var color_rect = $"CanvasLayer/ColorRect"

@export var fade_in_time: float = 1
@export var fade_out_time: float = 1

func _init():
	Global.fader = self


func _process(_delta):
	if color_rect.modulate.a > 0:
		color_rect.visible = true
	else:
		color_rect.visible = false


func fade_in() -> void:
	get_tree().create_tween().tween_property(color_rect, "modulate:a", 1, fade_in_time)
	await get_tree().create_timer(fade_in_time).timeout


func fade_out() -> void:
	get_tree().create_tween().tween_property(color_rect, "modulate:a", 0, fade_out_time)
	await get_tree().create_timer(fade_out_time).timeout


func set_modulate_a(modulate_value) -> void:
	color_rect.modulate.a = modulate_value
