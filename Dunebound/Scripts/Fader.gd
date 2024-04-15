extends Node2D

@onready var color_rect = $"CanvasLayer/ColorRect"

@export var fade_in_time: float = 1
@export var fade_out_time: float = 1

func fade_in() -> void:
	get_tree().create_tween().tween_property(color_rect, "modulate:a", 1, fade_in_time)

func fade_out() -> void:
	get_tree().create_tween().tween_property(color_rect, "modulate:a", 0, fade_out_time)
