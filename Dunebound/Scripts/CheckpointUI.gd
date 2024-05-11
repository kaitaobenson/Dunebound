extends Node2D

@onready var text = $"RichTextLabel"
var previous_fade_done: bool = true

func checkpoint():
	if previous_fade_done:
		previous_fade_done = false
		
		get_tree().create_tween().tween_property(text, "modulate:a", 1, 2)
		await get_tree().create_timer(2).timeout
		get_tree().create_tween().tween_property(text, "modulate:a", 0, 0.2)
		await get_tree().create_timer(0.2).timeout
		
		previous_fade_done = true
