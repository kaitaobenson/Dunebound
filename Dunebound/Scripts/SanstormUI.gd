extends Node2D

@onready var bar = $"TextureProgressBar"

#Value between 0 and 100
func set_bar(health:int):
	bar.set_value_no_signal(health)
